//
//  FixShapes.swift
//  
//
//  Created by Nail Sharipov on 14.08.2023.
//

public typealias FixShapes = [FixShape]

public extension FixShapes {
    @inlinable var pointsCount: Int {
        self.reduce(0, { $0 + $1.pointsCount })
    }
}
