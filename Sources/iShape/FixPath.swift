//
//  FixPath.swift
//  
//
//  Created by Nail Sharipov on 10.07.2023.
//

import iFixFloat

public typealias FixPath = [FixVec]

public extension FixPath {
    
    @inlinable
    /// The area of the `FixPath`.
    /// - Returns: The calculated area of the path
    var area: FixFloat {
        let n = self.count
        var p0 = self[n - 1]

        var area: FixFloat = 0
        
        for p1 in self {
            area += p1.unsafeCrossProduct(p0)
            p0 = p1
        }
        
        return area >> (FixFloat.fractionBits + 1)
    }
    
    @inlinable
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

}
