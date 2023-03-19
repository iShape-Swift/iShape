//
//  Contour.swift
//  
//
//  Created by Nail Sharipov on 14.03.2023.
//

import CoreGraphics

public typealias Contour = Array<Point>

public extension Contour {
    
    init(_ points: [CGPoint]) {
        self = Array(repeating: .zero, count: points.count)
        for i in 0..<points.count {
            self[i] = Point(points[i])
        }
    }
    
    @inlinable
    func int(_ space: Space) -> IntContour {
        space.int(self)
    }
}

public extension Array where Element == CGPoint {
    
    init(_ contour: Contour) {
        self = Array(repeating: .zero, count: contour.count)
        for i in 0..<contour.count {
            self[i] = CGPoint(contour[i])
        }
    }
}

public extension Array where Element == [CGPoint] {
    
    init(_ contours: [Contour]) {
        var result = Array<[CGPoint]>()
        result.reserveCapacity(contours.count)
        for contour in contours {
            result.append(Array<CGPoint>(contour))
        }
        self = result
    }
}
