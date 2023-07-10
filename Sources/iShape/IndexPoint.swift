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
    
    @inlinable
    public var mileStone: MileStone { MileStone(index: index) }
    
    @inlinable
    public func mileStone(point: FixVec) -> MileStone {
        MileStone(index: index, offset: self.point.sqrDistance(point))
    }
    
    public init(index: Int, point: FixVec) {
        self.index = index
        self.point = point
    }
}

