//
//  Contour+Offset.swift
//  
//
//  Created by Nail Sharipov on 22.03.2023.
//

import simd

public extension Contour {
    
    func offset(_ length: Float) -> Contour {
        let c = self.centroid()

        return offset(center: c, length: length)
    }
    
    func offset(center c: Point, length: Float) -> Contour {
        let n = count
        var result = [Point](repeating: .zero, count: n)
        
        var i = 0
        for a in self {
            let v = a - c
            if v.sqrLength() > 0.001 {
                let l = v.length()
                let k: Float = Swift.max(1 - length / l, 0.1)
                result[i] = k * v + c
            } else {
                result[i] = a
            }
            i += 1
        }

        return result
    }

    @inlinable
    func centroid() -> Point {
        var area: Float = 0.0
        var centroid = Point.zero

        var a = self[count - 1]
        for b in self {
            let crossProduct = a.crossProduct(b)
            area += crossProduct
            centroid = centroid + (a + b) * crossProduct
            a = b
        }

        area /= 2.0
        centroid = centroid / (6.0 * area)

        return centroid
    }

    func scale(_ s: Float) -> Contour {
        let c = self.centroid()

        return scale(center: c, scale: s)
    }
    
    func scale(center c: Point, scale s: Float) -> Contour {
        let n = count
        var result = [Point](repeating: .zero, count: n)
        
        var i = 0
        for a in self {
            let v = a - c
            result[i] = s * v + c
            i += 1
        }

        return result
    }
    
}
