//
//  FixShape.swift
//  
//
//  Created by Nail Sharipov on 10.07.2023.
//

import iFixFloat

/// Represents a fixed geometric shape with contour and holes.
public struct FixShape {
    
    /// The array of paths defining the contour and holes of the shape.
     public var paths: [FixPath]
     
     /// Indicates whether the shape is a convex polygon.
     public var isConvexPolygon: Bool {
         paths.count == 1 && contour.isConvex
     }
     
     /// The contour defining the outer boundary of the shape.
     /// It is always ordered in a clockwise direction.
     @inline(__always)
     public var contour: FixPath {
         paths[0]
     }

     /// The array of holes defining the inner boundaries of the shape.
     /// Each hole is ensured to be in a counter-clockwise order.
     @inline(__always)
     public var holes: ArraySlice<FixPath> {
         paths[1..<paths.count]
     }
     
     /// Initializes a new shape with the specified contour.
     /// Automatically adjusts the order of the contour to be clockwise.
     ///
     /// - Parameters:
     ///   - contour: The contour defining the outer boundary of the shape.
     @inline(__always)
     public init(contour: FixPath) {
         self.paths = [contour.isClockwiseOrdered ? contour : contour.reversed()]
     }
     
     /// Initializes a new shape with the specified contour and holes.
     /// Adjusts the order of the contour to be clockwise and holes to be counter-clockwise.
     ///
     /// - Parameters:
     ///   - contour: The contour defining the outer boundary of the shape.
     ///   - holes: The array of holes defining the inner boundaries of the shape.
     @inline(__always)
     public init(contour: FixPath, holes: [FixPath]) {
         self.paths = [contour.isClockwiseOrdered ? contour : contour.reversed()]
         self.paths.reserveCapacity(holes.count + 1)

         self.paths += holes.map { $0.isClockwiseOrdered ? $0.reversed() : $0 }
     }
     
     /// Initializes a new shape with the specified paths.
     /// The first path is used as the contour, and remaining paths as holes.
     /// No order adjustment is performed; paths should be properly ordered beforehand.
     ///
     /// - Parameters:
     ///   - paths: The array of paths defining the contour and holes.
     public init(paths: [FixPath]) {
         self.paths = paths
     }
     
     /// Adds a new hole to the shape.
     /// Automatically adjusts the order of the hole to be counter-clockwise.
     ///
     /// - Parameters:
     ///   - path: The path defining the hole to be added.
     public mutating func addHole(_ path: FixPath) {
         self.paths.append(path.isClockwiseOrdered ? path.reversed() : path)
     }
}
