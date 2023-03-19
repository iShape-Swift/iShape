//
//  IntContour.swift
//  
//
//  Created by Nail Sharipov on 14.03.2023.
//

public typealias IntContour = Array<IntPoint>

public extension IntContour {
    
    @inlinable
    var area: Int64 {
        var s: Int64 = 0
        var p1 = self[count - 1]
        for p2 in self {
            let dx = p2.x - p1.x
            let sy = p2.y + p1.y
            s += dx * sy
            p1 = p2
        }
        
        return s
    }
    
    @inlinable
    func float(_ space: Space) -> Contour {
        space.float(self)
    }
    
}
