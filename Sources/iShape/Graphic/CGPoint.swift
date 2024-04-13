//
//  CGPoint.swift
//  
//
//  Created by Nail Sharipov on 10.07.2023.
//

#if canImport(CoreGraphics)

import CoreGraphics
import iFixFloat

public extension CGPoint {
    @inline(__always)
    var fix: FixVec {
        FixVec(x: x.fix, y: y.fix)
    }
}

public extension FixVec {
    @inline(__always)
    var cgPoint: CGPoint {
        CGPoint(x: x.cgFloat, y: y.cgFloat)
    }
}

public extension Point {
    @inline(__always)
    var cgPoint: CGPoint {
        let x = CGFloat(self.x) / CGFloat(FixFloat.unit)
        let y = CGFloat(self.y) / CGFloat(FixFloat.unit)
        return CGPoint(x: x, y: y)
    }
}

#endif
