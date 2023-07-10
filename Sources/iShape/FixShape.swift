//
//  FixShape.swift
//  
//
//  Created by Nail Sharipov on 10.07.2023.
//

import iFixFloat

public struct FixShape {
    
    public let contour: FixPath
    public let holes: [FixPath]
    
    @inlinable
    public init(contour: FixPath, holes: [FixPath]) {
        self.contour = contour
        self.holes = holes
    }

}
