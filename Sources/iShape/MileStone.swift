//
//  MileStone.swift
//  
//
//  Created by Nail Sharipov on 10.07.2023.
//

import iFixFloat

public struct MileStone: Equatable, Hashable {
    
    public static let zero = MileStone(index: 0)

    public let index: Int
    public let offset: FixFloat

    @inlinable
    public init(index: Int, offset: FixFloat = 0) {
        self.index = index
        self.offset = offset
    }
    
    @inlinable
    public static func < (lhs: MileStone, rhs: MileStone) -> Bool {
        if lhs.index != rhs.index {
            return lhs.index < rhs.index
        }

        return lhs.offset < rhs.offset
    }
    
    @inlinable
    public static func > (lhs: MileStone, rhs: MileStone) -> Bool {
        if lhs.index != rhs.index {
            return lhs.index > rhs.index
        }

        return lhs.offset > rhs.offset
    }
    
    @inlinable
    public static func >= (lhs: MileStone, rhs: MileStone) -> Bool {
        if lhs.index != rhs.index {
            return lhs.index > rhs.index
        }

        return lhs.offset >= rhs.offset
    }
    
    @inlinable
    public static func == (lhs: MileStone, rhs: MileStone) -> Bool {
        return lhs.index == rhs.index && lhs.offset == rhs.offset
    }

}

#if DEBUG
extension MileStone: CustomStringConvertible {
    
    public var description: String {
        "(\(index), \(offset))"
    }
    
}
#endif
