//
//  FixShape.swift
//  
//
//  Created by Nail Sharipov on 10.07.2023.
//

import iFixFloat

// TODO implement ZipShape

public struct FixShape {
    
    public var contour: FixPath
    public var holes: [FixPath]
    
    @inline(__always)
    public init(contour: FixPath, holes: [FixPath]) {
        self.contour = contour
        self.holes = holes
    }

    public init(paths: [FixPath]) {
        let n = paths.count
        contour = paths[0]
        if n > 1 {
            var buffer = [FixPath]()
            buffer.reserveCapacity(n)
            var i = 1
            while i < n {
                buffer.append(paths[i])
                i += 1
            }
            holes = buffer
        } else {
            holes = []
        }
    }
}
