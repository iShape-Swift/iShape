//
//  Vertex.swift
//  
//
//  Created by Nail Sharipov on 15.03.2023.
//

public typealias Index = Int

public extension Index {
    static let null: Index = -1
}

public struct Vertex {
    
    public enum Nature {
        case origin
        case extraPath
        case extraInner
        case extraTessellated
        
        public var isPath: Bool {
            self == .origin || self == .extraPath
        }
    }
    
    public static let empty = Vertex(index: .null, nature: .origin, point: .zero)
    
    public let index: Index
    public let point: IntPoint
    public let nature: Nature

    public init(index: Index, nature: Nature, point: IntPoint) {
        self.index = index
        self.point = point
        self.nature = nature
    }
    
}
