//
//  CGPoint.swift
//  
//
//  Created by Nail Sharipov on 10.07.2023.
//

import CoreGraphics
import iFixFloat

public extension CGPoint {
    
    @inlinable
    var fix: FixVec {
        FixVec(x: x.fix, y: y.fix)
    }
    
}

public extension FixVec {

    @inlinable
    var cgPoint: CGPoint {
        CGPoint(x: x.cgFloat, y: y.cgFloat)
    }
    
}
