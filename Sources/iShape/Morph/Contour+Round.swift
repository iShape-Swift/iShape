//
//  Shape+Round.swift
//  
//
//  Created by Nail Sharipov on 21.03.2023.
//

public extension Contour {
    
    func round(radius: Float, ratio: Float = 0.2) -> Contour {
        let n = count
        var result = [Point]()
        result.reserveCapacity(4 * n)
        
        var a = self[n - 2]
        var b = self[n - 1]
        var v0 = Vector(a: a, b: b)
        for c in self {
            let v1 = Vector(a: b, b: c)
            
            let cornerPoints = Morph.roundCorner(v0, v1, radius: radius, ratio: ratio)
            result.append(contentsOf: cornerPoints)

            v0 = v1
            a = b
            b = c
        }

        return result
    }
    
    
   
}
