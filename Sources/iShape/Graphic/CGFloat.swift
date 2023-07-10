//
//  CGFloat.swift
//  
//
//  Created by Nail Sharipov on 10.07.2023.
//

import CoreGraphics
import iFixFloat

public extension CGFloat {
    
    @inlinable
    var fix: FixFloat {
        Int64(self * CGFloat(FixFloat.unit))
    }
    
}

public extension FixFloat {

    @inlinable
    var cgFloat: CGFloat {
        CGFloat(self) / CGFloat(FixFloat.unit)
    }
    
}
