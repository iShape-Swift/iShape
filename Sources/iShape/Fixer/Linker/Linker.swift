//
//  Linker.swift
//  
//
//  Created by Nail Sharipov on 14.11.2022.
//

import simd

private struct RegionResult {
    let region: [IntPoint]
}

private struct EdgeEnd {
    let point: IntPoint
    let edgeId: Int
}

private struct Link {
    var n0: Int
    var n1: Int
    
    @inlinable
    mutating func add(node: Int) {
        if n0 == -1 {
            n0 = node
        } else {
            n1 = node
        }
    }
}

struct Linker {

    typealias Edge = Fixer.Edge

    private let map: NodeMap
    
    @inlinable
    init(edges: [Edge]) {
        let n = 2 * edges.count
        
        var ends = [EdgeEnd]()
        ends.reserveCapacity(n)
        for i in 0..<edges.count {
            let edge = edges[i]
            ends.append(EdgeEnd(point: edge.start, edgeId: i))
            ends.append(EdgeEnd(point: edge.end, edgeId: i))
        }
        
        ends.sort(by: { $0.point.bitPack < $1.point.bitPack })
        ends.append(EdgeEnd(point: IntPoint(x: .max, y: .max), edgeId: .min)) // stop element
        
        var nodes = [Node]()
        nodes.reserveCapacity(2 * edges.count)
        var support = [Int]()
        support.reserveCapacity(16)
        
        var links = [Link](repeating: .init(n0: -1, n1: -1), count: edges.count)

        var j = 1
        var i = 1
        var e0 = ends[0]
        while i <= n {
            let e1 = ends[i]
            if e0.point == e1.point {
                j += 1
            } else {
                let nodeId = nodes.count
                for k in 1...j {
                    let e = ends[i - k].edgeId
                    var link = links[e]
                    link.add(node: nodeId)
                    links[e] = link
                }

                if j == 2 {
                    nodes.append(Node(index: nodes.count, point: e0.point, count: 2, i0: -1, i1: -1))
                } else {
                    nodes.append(Node(index: nodes.count, point: e0.point, count: j, i0: support.count, i1: 0))
                    for _ in 0..<j {
                        support.append(-1)
                    }
                }

                j = 1
            }
            e0 = e1
            i += 1
        }
        
        for link in links {
            var n0 = nodes[link.n0]
            var n1 = nodes[link.n1]
            if n0.count == 2 {
                n0.add(index: link.n1)
            } else {
                support[n0.i0 + n0.i1] = link.n1
                n0.i1 += 1
            }
            if n1.count == 2 {
                n1.add(index: link.n0)
            } else {
                support[n1.i0 + n1.i1] = link.n0
                n1.i1 += 1
            }
            
            nodes[n0.index] = n0
            nodes[n1.index] = n1
        }

        self.map = NodeMap(nodes: nodes, support: support)
    }
    
    @inlinable
    func join() -> [[IntPoint]] {
        guard map.nodes.count > 2 else { return [] }
        
        var regions = [[IntPoint]]()
        
        var na = map.nodes[0] // the most left point
        
        var path = Path(count: map.nodes.count)
        path.add(na)

        var nb = self.first(na)
        path.add(nb)
        var nc = nb

        repeat {
            nc = self.next(na: na, nb: nb)
            if path.isContain(nc) {
                let points = path.slice(node: nc)
                if !points.isEmpty {
                    regions.append(points)
                }
            }
            path.add(nc)
            na = nb
            nb = nc
        } while nc.index != 0

        return regions
    }
    
    private func first(_ na: Node) -> Node {
        var it = NodeIterator(na)
        
        let a = na.point
        var nb = it.next(map)
        
        while it.hasNext {
            let nc = it.next(map)
            let ba = nb.point - a
            let ca = nc.point - a
            let crossProduct = ba.crossProduct(ca)
            if crossProduct > 0 {
                nb = nc
            }
        }
        
        return nb
    }
    
    private func next(na: Node, nb: Node) -> Node {
        guard nb.count != 2 else {
            let i = nb.i0 == na.index ? nb.i1 : nb.i0
            return map.nodes[i]
        }
        
        let b = nb.point
        
        
        let ba = Point(x: Float(b.x - na.point.x), y: Float(b.y - na.point.y)).normalize
        
        var it = NodeIterator(nb)
        
        var nx = nb
        var max: Float = -3.0
        
        while it.hasNext {
            let nc = it.next(map)
            guard nc.index != na.index else {
               continue
            }

            let c = nc.point
            let bc = Point(x: Float(c.x - b.x), y: Float(c.y - b.y))
            
            let value = ba.clockWiseSortValue(bc)
            if value > max {
                nx = nc
                max = value
            }
        }
        
        return nx
    }
    
}

private extension Point {

    func clockWiseSortValue(_ a: Point) -> Float {
        let v = simd_normalize(a)
        let cos = self.dotProduct(v)
        let cross = self.crossProduct(v)
        let sign: Float = cross > 0 ? 1 : -1
        return sign * (1 - cos)
    }

}
