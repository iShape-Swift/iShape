//
//  IndexPoint.swift
//  
//
//  Created by Nail Sharipov on 10.07.2023.
//

import iFixFloat

public struct IndexPoint {
    
    public static let zero = IndexPoint(index: 0, point: .zero)
    
    public let index: Int
    public let point: FixVec
    
    public init(index: Int, point: FixVec) {
        self.index = index
        self.point = point
    }
}

