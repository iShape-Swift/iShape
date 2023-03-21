//
//  Fixer+Edge.swift
//  
//
//  Created by Nail Sharipov on 09.11.2022.
//

extension Fixer {
    
    @usableFromInline
    struct Edge: Hashable {
        
        let start: IntPoint
        let end: IntPoint

        @inlinable
        func hash(into hasher: inout Hasher) {
            hasher.combine(start.bitPack)
            hasher.combine(end.bitPack)
        }

        @inlinable
        public static func == (lhs: Edge, rhs: Edge) -> Bool {
            return lhs.start == rhs.start && lhs.end == rhs.end
        }
    }
}
