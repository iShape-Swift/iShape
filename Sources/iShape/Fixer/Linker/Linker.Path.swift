//
//  Path.swift
//  
//
//  Created by Nail Sharipov on 15.11.2022.
//

extension Linker {
    
    struct Path {
        
        private var points: [IntPoint]
        private var indices: [Int]
        private var set: [Int]
        
        @inlinable
        init(count: Int) {
            points = [IntPoint]()
            points.reserveCapacity(count)
            indices = [Int]()
            indices.reserveCapacity(count)
            set = [Int](repeating: -1, count: count)
        }
        
        @inlinable
        func isContain(_ node: Linker.Node) -> Bool {
            set[node.index] != -1
        }
        
        @inlinable
        mutating func add(_ node: Linker.Node) {
            set[node.index] = points.count
            points.append(node.point)
            indices.append(node.index)
        }
        
        @inlinable
        mutating func slice(node: Linker.Node) -> [IntPoint] {
            let start = set[node.index]
            let n = points.count
            guard start < n else {
                return []
            }

            for i in start..<n {
                let index = indices[i]
                set[index] = -1
            }
            
            let result: [IntPoint]
            let count = n - start
            if count > 2 {
                if start != 0 {
                    result = Array(points[start..<n])
                } else {
                    result = points
                }
            } else {
                result = []
            }
            
            points.removeLast(count)
            indices.removeLast(count)

            return result
        }
    }
}
