//
//  Vector.swift
//  
//
//  Created by Nail Sharipov on 21.03.2023.
//

import simd

struct Vector {

    static let empty = Vector(a: .zero, b: .zero, unit: .zero, length: 0)
    
    let a: Point
    let b: Point
    let unit: Point
    let length: Float
    
    @inlinable
    init(a: Point, b: Point) {
        let ba = b - a
        self.a = a
        self.b = b
        self.length = ba.length()
        self.unit = ba / length
    }
    
    @inlinable
    init(a: Point, b: Point, unit: Point, length: Float) {
        self.a = a
        self.b = b
        self.unit = unit
        self.length = length
    }
}
