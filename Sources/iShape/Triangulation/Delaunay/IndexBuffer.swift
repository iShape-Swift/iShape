//
//  IndexBuffer.swift
//  
//
//  Created by Nail Sharipov on 15.03.2023.
//

struct IndexBuffer {
    
    private struct Link {
        static let empty = Link(empty: true, next: .null)
        let empty: Bool
        var next: Index
    }
    
    private var array: [Link]
    private var first: Int
    
    @inlinable
    var hasNext: Bool { first >= 0}
    
    init(count: Int) {
        guard count > 0 else {
            self.array = []
            self.first = .null
            return
        }
        self.first = 0
        self.array = [Link](repeating: .empty, count: count)
        for i in 0..<count {
            self.array[i] = Link(empty: false, next: i + 1)
        }
        self.array[count - 1].next = .null
    }

    @inlinable
    mutating func next() -> Int {
        let index = first
        first = array[index].next
        
        array[index] = .empty

        return index
    }

    @inlinable
    mutating func add(index: Int) {
        let isOverflow = index >= self.array.count
        if isOverflow || self.array[index].empty {
            if isOverflow {
                let n = index - self.array.count
                for _ in 0...n {
                    self.array.append(.empty)
                }
            }
            array[index] = Link(empty: false, next: first)

            first = index
        }
    }

}
