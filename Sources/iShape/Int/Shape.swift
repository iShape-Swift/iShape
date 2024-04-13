//
//  Shape.swift
//
//
//  Created by Nail Sharipov on 06.04.2024.
//

public typealias Shape = [Path]
public typealias Shapes = [Shape]

public extension Shape {
    
    @inlinable var pointsCount: Int {
        self.reduce(0, { $0 + $1.count })
    }
    
    @inlinable var fix: FixShape {
        FixShape(paths: self.map({ $0.fix }))
    }
    
    /// Indicates whether the shape is a convex polygon.
    @inlinable var isConvexPolygon: Bool {
        self.count == 1 && self[0].isConvex
    }
    
}

public extension Shapes {
    @inlinable var pointsCount: Int {
        self.reduce(0, { $0 + $1.pointsCount })
    }
}
