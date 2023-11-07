//
//  FixShape.swift
//  
//
//  Created by Nail Sharipov on 10.07.2023.
//

import iFixFloat

/// Represents a fixed geometric shape with contour and holes.
public struct FixShape {
    
    public var paths: [FixPath]
    
    public var isConvexPolygon: Bool {
        paths.count == 1 && contour.isConvex
    }
    
    /// The contour defining the outer boundary of the shape.
    @inline(__always)
    public var contour: FixPath {
        paths[0]
    }

    /// The array of holes defining the inner boundaries of the shape.
    @inline(__always)
    public var holes: ArraySlice<FixPath> {
        paths[1..<paths.count]
    }
    
    /// Initializes a new shape with the specified contour.
    ///
    /// - Parameters:
    ///   - contour: The contour defining the outer boundary of the shape.
    @inline(__always)
    public init(contour: FixPath) {
        paths = [contour]
    }
    
    /// Initializes a new shape with the specified contour and holes.
    ///
    /// - Parameters:
    ///   - contour: The contour defining the outer boundary of the shape.
    ///   - holes: The array of holes defining the inner boundaries of the shape.
    @inline(__always)
    public init(contour: FixPath, holes: [FixPath]) {
        paths = [FixPath]()
        paths.reserveCapacity(holes.count + 1)
        paths.append(contour)
        paths.append(contentsOf: holes)
    }
    
    /// Initializes a new shape with the specified paths.
    /// The first path is used as the contour, and remaining paths as holes.
    ///
    /// - Parameters:
    ///   - paths: The array of paths defining the contour and holes.
    public init(paths: [FixPath]) {
        self.paths = paths
    }
    
    /// Sets the direction of the contour and holes.
    /// If the clockwise parameter is true, the contour and holes will be arranged in a clockwise direction.
    /// If false, they will be arranged in a counter-clockwise direction.
    ///
    /// - Parameters:
    ///   - clockwise: A Boolean value that determines whether the direction is clockwise.
    public mutating func setDirection(clockwise: Bool) {
        for i in 0..<paths.count {
            var path = paths[i]
            if (path.area < 0) == clockwise {
                path.reverse()
                paths[i] = path
            }
        }
    }
    
    /// Adds a new hole to the shape.
    ///
    /// - Parameters:
    ///   - path: The path defining the hole to be added.
    public mutating func addHole(_ path: FixPath) {
        self.paths.append(path)
    }
}
