//
//  FixShape.swift
//  
//
//  Created by Nail Sharipov on 10.07.2023.
//

import iFixFloat

// TODO implement ZipShape

/// Represents a fixed geometric shape with contour and holes.
public struct FixShape {
    
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

    public var paths: [FixPath]
    
    /// Initializes a new shape with the specified contour and holes.
    ///
    /// - Parameters:
    ///   - contour: The contour defining the outer boundary of the shape.
    ///   - holes: The array of holes defining the inner boundaries of the shape.
    ///   - validateDirection: Optional parameter to check that all paths are in a clockwise direction. Default is true.
    @inline(__always)
    public init(contour: FixPath, holes: [FixPath], validateDirection: Bool = true) {
        paths = [FixPath]()
        paths.reserveCapacity(holes.count + 1)
        paths.append(contour)
        paths.append(contentsOf: holes)
        if validateDirection {
            self.setDirection(clockwise: true)
        }
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
