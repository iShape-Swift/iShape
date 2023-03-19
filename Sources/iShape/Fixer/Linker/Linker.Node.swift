//
//  Node.swift
//  
//
//  Created by Nail Sharipov on 14.11.2022.
//

extension Linker {
    
    struct Node {
        let index: Int
        let point: IntPoint
        let count: Int
        var i0: Int  // node index or index in edges array
        var i1: Int  // node index
        
        @inlinable
        mutating func add(index: Int) {
            if i0 == -1 {
                i0 = index
            } else {
                i1 = index
            }
        }
    }
    
    struct NodeMap {
        let nodes: [Node]
        let support: [Int]
    }
    
    struct NodeIterator {
        
        let node: Node
        private var index: Int = 0
        
        @inlinable
        init(_ node: Node) {
            self.node = node
        }
        
        @inlinable
        var hasNext: Bool {
            index < node.count
        }
        
        @inlinable
        mutating func next(_ map: NodeMap) -> Node {
            if node.count == 2 {
                if index == 0 {
                    index += 1
                    return map.nodes[node.i0]
                } else {
                    index += 1
                    return map.nodes[node.i1]
                }
            } else {
                let i = map.support[node.i0 + index]
                index += 1
                return map.nodes[i]
            }
        }
    }
}
