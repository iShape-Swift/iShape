//
//  Point.swift
//  
//
//  Created by Nail Sharipov on 14.03.2023.
//

import simd
import CoreGraphics

public typealias Point = simd_float2

public extension Point {
    
    init(_ point: CGPoint) {
        self.init(Float(point.x), Float(point.y))
    }

    @inlinable
    var normalize: Point {
        simd_normalize(self)
    }
    
    @inlinable
    func dotProduct(_ vector: Point) -> Float { // cos
        simd_dot(self, vector)
    }
    
    @inlinable
    func crossProduct(_ vector: Point) -> Float {
        self.x * vector.y - self.y * vector.x
    }

}

public extension CGPoint {
    
    init(_ point: Point) {
        self.init(x: CGFloat(point.x), y: CGFloat(point.y))
    }
    
}

