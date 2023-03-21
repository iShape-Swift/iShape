//
//  IntShape.swift
//  
//
//  Created by Nail Sharipov on 14.03.2023.
//

public struct IntShape {
    
    public static let empty: IntShape = IntShape(contour: [], holes: [])
    
    public var contour: IntContour
    public var holes: [IntContour]

    @inlinable
    public var pointsCount: Int {
        contour.count + holes.reduce(0, { $0 + $1.count })
    }
    
    @inlinable
    public var points: [IntPoint] {
        var result = [IntPoint]()
        result.reserveCapacity(pointsCount)
        
        result.append(contentsOf: contour)
        
        for hole in holes {
            result.append(contentsOf: hole)
        }
        
        return result
    }
    
    @inlinable
    public init(contour: IntContour, holes: [IntContour] = []) {
        self.contour = contour
        self.holes = holes
    }
    
    @inlinable
    public func float(_ space: Space) -> Shape {
        Shape(contour: contour.float(space), holes: space.float(contours: holes))
    }
    
}
