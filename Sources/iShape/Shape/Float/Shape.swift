//
//  Shape.swift
//  
//
//  Created by Nail Sharipov on 14.03.2023.
//

import simd

public struct Shape {
    
    public static let empty: Shape = Shape(contour: [], holes: [])
    
    public var contour: Contour
    public var holes: [Contour]

    @inlinable
    public var pointsCount: Int {
        contour.count + holes.reduce(0, { $0 + $1.count })
    }
    
    @inlinable
    public var points: [Point] {
        var result = [Point]()
        result.reserveCapacity(pointsCount)
        
        result.append(contentsOf: contour)
        
        for hole in holes {
            result.append(contentsOf: hole)
        }
        
        return result
    }
    
    @inlinable
    public init(contour: Contour, holes: [Contour] = []) {
        self.contour = contour
        self.holes = holes
    }
    
    @inlinable
    public func int(_ space: Space) -> IntShape {
        IntShape(contour: space.int(contour), holes: space.int(holes))
    }
    
}
