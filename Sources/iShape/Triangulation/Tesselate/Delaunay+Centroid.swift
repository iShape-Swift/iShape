//
//  Delaunay+Centroid.swift
//  
//
//  Created by Nail Sharipov on 22.03.2023.
//

public extension Delaunay {
    
    private struct Detail {
        let center: IntPoint
        let count: Int
    }

    func makeCentroidNet(minArea: Int64 = 0) -> [IntContour] {
        let n = self.triangles.count

        var visitedIndex = Array<Bool>(repeating: false, count: points.count)
        var result = [IntContour]()

        for i in 0..<n {
            let triangle = self.triangles[i]
            for j in 0...2 {
                let v = triangle.vertices[j]
                guard !visitedIndex[v.index] else {
                    continue
                }

                if v.nature.isPath {
                    var t = triangles[i]
                    let vi = t.index(index: v.index)
                    let prevVi = (vi - 1) % 3
                    var nextVi = (vi + 1) % 3
                    if t.neighbors[prevVi] == .null {

                        var path = [IntPoint]()
                        path.reserveCapacity(16)
                        
                        let p0 = v.point
                        var pl = t.middle(index: prevVi)
                        var pc = t.center
                        
                        path.append(p0)
                        path.append(pl)
                        path.append(pc)
                        
                        var a = pl - p0
                        
                        var next = t.neighbors[nextVi]

                        while next >= 0 {
                            t = self.triangles[next]
                            
                            pc = t.center

                            if a.crossProduct(p0 - pc) < 0 {
                                result.append(path)
                                pl = path[path.count - 1]
                                path.removeAll()
                                path.append(p0)
                                path.append(pl)
                                a = pl - p0
                            }
                            
                            path.append(pc)

                            let vIndex = t.index(index: v.index)
                            nextVi = (vIndex + 1) % 3

                            next = t.neighbors[nextVi]
                        }
                        pl = t.middle(index: nextVi)
                        
                        if a.crossProduct(p0 - pl) < 0 {
                            path.append(pl)
                        }

                        if minArea == 0 || path.area > minArea  {
                            result.append(path)
                        }

                        visitedIndex[v.index] = true
                    }
                } else {
                    var path = [IntPoint]()
                    path.reserveCapacity(16)
                    let start = i
                    var next = start
                    
                    repeat {
                        let t = self.triangles[next]
                        path.append(t.center)
                        
                        let vIndex = t.index(index: v.index)
                        let nextIndex = (vIndex + 1) % 3

                        next = t.neighbors[nextIndex]
                    } while next != start && next >= 0

                    if minArea == 0 || path.area > minArea  {
                        result.append(path)
                    }
                    
                    visitedIndex[v.index] = true
                }
                
            }
        }

        return result
    }
    
}


private extension Delaunay.Triangle {
    
    var center: IntPoint {
        let a = self.vertices.a.point
        let b = self.vertices.b.point
        let c = self.vertices.c.point
        let x = (a.x + b.x + c.x) / 3
        let y = (a.y + b.y + c.y) / 3
        return IntPoint(x: x, y: y)
    }

    
    func middle(index: Int) -> IntPoint {
        switch index {
        case 0:
            return (vertices.b.point + vertices.c.point).middle
        case 1:
            return (vertices.a.point + vertices.c.point).middle
        default:
            return (vertices.a.point + vertices.b.point).middle
        }
    }
}

private extension IntPoint {

    var middle: IntPoint {
        IntPoint(x: x >> 1, y: y >> 1)
    }
}
