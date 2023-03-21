//
//  Shape+Divide.swift
//  
//
//  Created by Nail Sharipov on 21.03.2023.
//

public extension IntShape {

    mutating func divide(maxEdge: Float, space: Space) {
        self.contour.divide(maxEdge: maxEdge, space: space)
        
        for i in 0..<holes.count {
            var hole = holes[i]
            hole.divide(maxEdge: maxEdge, space: space)
            holes[i] = hole
        }
    }
}
