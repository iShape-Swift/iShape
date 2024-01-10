//
//  FixPath.swift
//  
//
//  Created by Nail Sharipov on 10.07.2023.
//

import iFixFloat

public typealias FixPath = [FixVec]

public extension FixPath {
    
    /// The area of the `FixPath`.
    /// - Returns: The calculated area of the path
    var unsafeArea: FixFloat {
        let n = self.count
        var p0 = self[n - 1]

        var area: FixFloat = 0
        
        for p1 in self {
            area += p1.crossProduct(p0)
            p0 = p1
        }
        
        return area
    }    
    
    /// The area of the `FixPath`.
    /// - Returns: The calculated area of the path
    var fixArea: FixFloat {
        self.unsafeArea >> (FixFloat.fractionBits + 1)
    }

    /// Determines if the `FixPath` is convex.
    ///
    /// A convex polygon is a simple polygon (not self-intersecting) in which
    /// the line segment between any two points along the boundary never
    /// goes outside the polygon. This method assumes that the points in `FixPath`
    /// are ordered (either clockwise or counter-clockwise) and the path is not
    /// self-intersecting.
    ///
    /// - Returns: A Boolean value indicating whether the path is convex.
    ///   - Returns `true` if the path is convex.
    ///   - Returns `false` otherwise.
    var isConvex: Bool {
        let n = self.count
        guard n > 2 else { return true }
        
        let p0 = self[n - 2]
        var p1 = self[n - 1]
        var e0 = p1 - p0
        var sign: Int64 = 0
        for p2 in self {
            let e1 = p2 - p1
            let cross = e1.crossProduct(e0).signum()
            if cross == 0 {
                let dot = e1.dotProduct(e0);
                if dot == -1 {
                    return false
                }
            } else {
                if sign == 0 {
                    sign = cross
                } else if sign != cross {
                    return false
                }
            }
            e0 = e1
            p1 = p2
        }
        
        return true
    }
    
    /// The wind direction of the `FixPath`.
    /// - Returns: A Boolean value indicating whether the path is clockwise ordered.
    ///  - Returns `true` if the path is clockwise ordered.
    ///  - Returns `false` otherwise.
    var isClockwiseOrdered: Bool {
        self.unsafeArea >= 0
    }
    
    
    /// Checks if a point is contained within the `FixPath`.
    /// - Parameter p: The `FixVec` point to check.
    /// - Returns: A boolean value indicating whether the point is within the path.
    func contains(point p: FixVec) -> Bool {
        let n = self.count
        var isContain = false
        var b = self[n - 1]
        for i in 0..<n {
            let a = self[i]
            
            let isInRange = (a.y > p.y) != (b.y > p.y)
            if isInRange {
                let dx = b.x - a.x
                let dy = b.y - a.y
                let sx = (p.y - a.y) * dx / dy + a.x
                if p.x < sx {
                    isContain = !isContain
                }
            }
            b = a
        }
        
        return isContain
    }
    

    /// Checks if the current `FixPath` is equal to another `FixPath`.
    /// It only works correctly with paths without duplicates.
    /// - Parameter other: The `FixPath` to compare to the current path.
    /// - Returns: A boolean value indicating whether the paths are equal.
    func isEqualTo(_ other: [FixVec]) -> Bool {
        let n = count
        guard n == other.count else { return false }
        
        let a0 = self[0]

        var ib = 0
        
        while ib < n {
            if other[ib] == a0 {
                break
            }
            ib += 1
        }

        guard ib < n else {
            return false
        }
        
        var ia = 1
        while ia < n {
            ib = (ib + 1) % n

            if other[ib] != self[ia] {
                return false
            }
            
            ia += 1
        }

        return true
    }
    
    /// Removes any degenerate points from the `FixPath`.
    /// Degenerate points are those that are collinear with their adjacent points.
    /// After removal, the path must contain at least three non-degenerate points, or it will be cleared.
    mutating func removeDegenerates() {
        guard count > 2 else {
            return self.removeAll()
        }
        
        guard self.hasDegenerates() else {
            return
        }
        
        self = self.filter()
    }
    
    /// Creates a new path by removing degenerate points from the current `FixPath`.
    /// Similar to `removeDegenerates`, but returns a new path rather than mutating the current one.
    /// - Returns: A new `FixVec` array with degenerates removed, or an empty array if there are fewer than three non-degenerate points.
    func removedDegenerates() -> [FixVec] {
        guard count > 2 else {
            return []
        }
        
        guard self.hasDegenerates() else {
            return self
        }
        
        return self.filter()
    }
    
    
    private func hasDegenerates() -> Bool {
        var p0 = self[count - 2]
        let p1 = self[count - 1]
        
        var v0 = p1 - p0
        p0 = p1
        
        for pi in self {
            let vi = pi - p0
            let prod = vi.crossProduct(v0)
            if prod == 0 {
                return true
            }
            v0 = vi
            p0 = pi
        }

        return false
    }
    
    
    private func filter() -> [FixVec] {
        var n = count
        
        var nodes = [Node](repeating: .init(next: .zero, index: .zero, prev: .zero), count: n)
        var validated = [Bool](repeating: false, count: n)
        var i0 = n - 2
        var i1 = n - 1
        for i2 in 0..<n {
            nodes[i1] = Node(next: i2, index: i1, prev: i0)
            i0 = i1
            i1 = i2
        }

        var first = 0
        
        var node = nodes[first]
        var i = 0
        while i < n {
            guard !validated[node.index] else {
                node = nodes[node.next]
                continue
            }
            
            let p0 = self[node.prev]
            let p1 = self[node.index]
            let p2 = self[node.next]

            if (p1 - p0).crossProduct(p2 - p1) == 0 {
                n -= 1
                if n < 3 {
                    return []
                }

                nodes.remove(node: node)
                if node.index == first {
                    first = node.next
                }

                node = nodes[node.prev]
                
                if validated[node.prev] {
                    i -= 1
                    validated[node.prev] = false
                }
                
                if validated[node.next] {
                    i -= 1
                    validated[node.next] = false
                }
                
                if validated[node.index] {
                    i -= 1
                    validated[node.index] = false
                }
            } else {
                validated[node.index] = true
                i += 1
                node = nodes[node.next]
            }
        }
        
        i = 0
        var buffer = [FixVec](repeating: .zero, count: n)
        node = nodes[first]
        while i < n {
            buffer[i] = self[node.index]
            node = nodes[node.next]
            i += 1
        }

#if DEBUG
        var a0 = buffer[buffer.count - 1]
        for p0 in buffer {
            assert(a0 != p0)
            a0 = p0
        }
#endif
        return buffer
    }
}

private struct Node {
    
    let next: Int
    let index: Int
    let prev: Int

    init(next: Int, index: Int, prev: Int) {
        self.next = next
        self.index = index
        self.prev = prev
    }
}

private extension Array where Element == Node {
    
    mutating func remove(node: Node) {
        let prev = self[node.prev]
        let next = self[node.next]
        self[node.prev] = Node(next: node.next, index: prev.index, prev: prev.prev)
        self[node.next] = Node(next: next.next, index: next.index, prev: node.prev)
    }

}
