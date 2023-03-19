//
//  IntShape+ShapeNavigator.swift
//  
//
//  Created by Nail Sharipov on 15.03.2023.
//

extension IntShape {

    enum LinkNature: Int {
        case end
        case start
        case split
        case extra
        case merge
        case simple
    }
    
    struct ShapeNavigator {
        let pathCount: Int
        let extraCount: Int
        let links: [Link]
        let natures: [LinkNature]
        let sortIndices: [Int]
    }
    
    private struct SortData {
        let index: Int
        let factor: Int64
    }
    
    func createNavigator(maxEdge: Int64, extraPoints: [IntPoint]?) -> ShapeNavigator {
        let pointsCount = contour.count + holes.reduce(0, { $0 + $1.count })
        
        let n: Int
        let extraCount: Int
        if let extraPoints = extraPoints {
            extraCount = extraPoints.count
            n = pointsCount + extraCount
        } else {
            n = pointsCount
            extraCount = 0
        }

        var links = Array<Link>(repeating: .empty, count: n)
        var natures = Array<LinkNature>(repeating: .simple, count: n)

        let count = contour.count
        var prev = count - 2
        var this = count - 1
        
        var a = contour[prev]
        var b = contour[this]
        var A = a.bitPack
        var B = b.bitPack
        
        for next in 0..<count {
            let c = contour[next]
            let C = c.bitPack
            
            var nature: LinkNature = .simple
            
            let isCCW = IntTriangle.isCCW(a: a, b: b, c: c)
            
            if A > B && B < C {
                if isCCW {
                    nature = .start
                } else {
                    nature = .split
                }
            }
            
            if A < B && B > C {
                if isCCW {
                    nature = .end
                } else {
                    nature = .merge
                }
            }

            let verNature: Vertex.Nature = .origin
            
            links[this] = Link(prev: prev, this: this, next: next, vertex: Vertex(index: this, nature: verNature, point: b))
            natures[this] = nature
            
            a = b
            b = c
            
            A = B
            B = C
            
            prev = this
            this = next
        }
        
        var offset = count
        
        for hole in holes {
            let holeCount = hole.count
            var prev = holeCount - 2
            var this = holeCount - 1

            var a = hole[prev]
            var b = hole[this]
            var A = a.bitPack
            var B = b.bitPack

            prev += offset
            this += offset
            
            for i in 0..<holeCount {
                let c = hole[i]
                let C = c.bitPack
                
                var nature: LinkNature = .simple
                
                let isCCW = IntTriangle.isCCW(a: a, b: b, c: c)
                
                if A > B && B < C {
                    if isCCW {
                        nature = .start
                    } else {
                        nature = .split
                    }
                }
                
                if A < B && B > C {
                    if isCCW {
                        nature = .end
                    } else {
                        nature = .merge
                    }
                }

                let verNature: Vertex.Nature = .origin
                
                let next = i + offset
                
                links[this] = Link(
                    prev: prev,
                    this: this,
                    next: next,
                    vertex: Vertex(
                        index: this,
                        nature: verNature,
                        point: b
                    )
                )
                natures[this] = nature
                
                a = b
                b = c
                
                A = B
                B = C
                
                prev = this
                this = next
            }
            
            offset += holeCount
        }
        
        if let extraPoints = extraPoints {
            for i in 0..<extraPoints.count {
                let p = extraPoints[i]
                let j = i + pointsCount
                links[j] = Link(prev: j, this: j, next: j, vertex: Vertex(index: j, nature: .extraInner, point: p))
                natures[j] = .extra
            }
        }

        // sort

        var dataList = Array<SortData>(repeating: SortData(index: 0, factor: 0), count: n)
        for i in 0..<n {
            let p = links[i].vertex.point
            dataList[i] = SortData(index: i, factor: p.bitPack)
        }
        
        dataList.sort(by: {
            a, b in
            if a.factor != b.factor {
                return a.factor < b.factor
            } else {
                let nFactorA = natures[a.index].rawValue
                let nFactorB = natures[b.index].rawValue
                
                return nFactorA < nFactorB
            }
        })
        
        var indices = Array<Int>(repeating: 0, count: n)
        
        // filter same points
        var sb = SortData(index: -1, factor: .min)
        var i = 0

        while i < n {
            var sa = dataList[i]
            indices[i] = sa.index
            if sa.factor == sb.factor {
                let v = links[sb.index].vertex
                repeat {
                    let link = links[sa.index]
                    links[sa.index] = Link(prev: link.prev, this: link.this, next: link.next, vertex: Vertex(index: v.index, nature: v.nature, point: link.vertex.point))
                    i += 1
                    if i < n {
                        sa = dataList[i]
                        indices[i] = sa.index
                    } else {
                        break
                    }
                } while sa.factor == sb.factor
            }
            sb = sa
            i += 1
        }

        return ShapeNavigator(pathCount: pointsCount, extraCount: extraCount, links: links, natures: natures, sortIndices: indices)
    }
}
