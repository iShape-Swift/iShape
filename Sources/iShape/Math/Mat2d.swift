//
//  Mat2d.swift
//  
//
//  Created by Nail Sharipov on 25.03.2023.
//

import simd

public typealias Mat2d = float2x2

public extension Mat2d {
    
    @inlinable
    init(angle: Float) {
        let cs = cos(angle)
        let sn = sin(angle)
        self.init(simd_float2(cs, -sn), simd_float2(sn, cs))
    }
    
    @inlinable
    init(cos: Float, sin: Float) {
        self.init(simd_float2(cos, -sin), simd_float2(sin, cos))
    }
 
}
