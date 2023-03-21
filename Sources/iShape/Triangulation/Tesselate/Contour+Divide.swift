//
//  Contour+Divide.swift
//  
//
//  Created by Nail Sharipov on 21.03.2023.
//

import simd

public extension IntContour {
    
    mutating func divide(maxEdge: Float, space: Space) {
        var result = IntContour()
        
        result.reserveCapacity(2 * count)
        
        let sqrEdge = space.int(maxEdge * maxEdge)
        
        var a = self[count - 1]
        
        for b in self {
            result.append(a)
            let sqrL = a.sqrDistance(point: b)
            if sqrL > sqrEdge {
                let vA = space.float(a)
                let vB = space.float(b)
                let vBA = vB - vA
                
                let l = vBA.length()
                let uBA = vBA / l
                
                let n = Int(l / maxEdge + 0.99999)
                let e = l / Float(n)

                var dv = e
                for _ in 1..<n {
                    let pA = space.int(vA + dv * uBA)
                    dv += e

                    result.append(pA)
                }
            }
            a = b
        }
        
        self = result
    }
    
}
