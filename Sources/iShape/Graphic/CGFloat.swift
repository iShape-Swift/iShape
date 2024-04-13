//
//  CGFloat.swift
//  
//
//  Created by Nail Sharipov on 10.07.2023.
//

#if canImport(CoreGraphics)

import CoreGraphics
import iFixFloat

public extension CGFloat {
    @inline(__always)
    var fix: FixFloat {
        Int64(self * CGFloat(FixFloat.unit))
    }
}

public extension FixFloat {
    @inline(__always)
    var cgFloat: CGFloat {
        CGFloat(self) / CGFloat(FixFloat.unit)
    }
}

#endif
