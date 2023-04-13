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

    @inlinable
    func length() -> Float {
        simd_length(self)
    }
    
    @inlinable
    func sqrLength() -> Float {
        x * x + y * y
    }
    
    @inlinable
    func sqrDistance(_ point: Point) -> Float {
        simd_distance(self, point)
    }
    
}

public extension CGPoint {
    
    init(_ point: Point) {
        self.init(x: CGFloat(point.x), y: CGFloat(point.y))
    }
    
}

