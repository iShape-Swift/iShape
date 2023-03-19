//
//  SwipeLineEventList.swift
//  
//
//  Created by Nail Sharipov on 18.03.2023.
//

struct SwipeLineEventList {
    
    private var events: [SwipeLineEvent]
    
    @inlinable
    var hasNext: Bool { !events.isEmpty }
    
    @inlinable
    mutating func next() -> SwipeLineEvent {
        events.removeLast()
    }
    
    init(edges: [Fixer.Edge]) {
        var result = [SwipeLineEvent]()
        let capacity = 2 * (edges.count + 4)
        result.reserveCapacity(capacity)
        
        for i in 0..<edges.count {
            let edge = edges[i]

#if DEBUG
            result.append(SwipeLineEvent(sortValue: edge.end.bitPack, action: .remove, edgeId: i, point: edge.end))
            result.append(SwipeLineEvent(sortValue: edge.start.bitPack, action: .add, edgeId: i, point: edge.start))
#else
            result.append(SwipeLineEvent(sortValue: edge.end.bitPack, action: .remove, edgeId: i))
            result.append(SwipeLineEvent(sortValue: edge.start.bitPack, action: .add, edgeId: i))
#endif

        }
     
        result.sort(by: {
            if $0.sortValue != $1.sortValue {
                return $0.sortValue > $1.sortValue
            } else {
                let a = $0.action.rawValue
                let b = $1.action.rawValue
                return a > b
            }
        })
        
        self.events = result
    }
    
    mutating func add(event: SwipeLineEvent) {
        let index: Int
        switch event.action {
        case .add:
            index = events.findRightIndex(value: event.sortValue)
        case .remove:
            index = events.findLeftIndex(value: event.sortValue)
        }
        events.insert(event, at: index)
    }
    
    
}

// Binary search for reversed array
private extension Array where Element == SwipeLineEvent {

    func findLeftIndex(value a: Int64) -> Int {
        var left = 0
        var right = count - 1

        var j = -1
        var i = (left + right) / 2
        var x = self[i].sortValue
        
        while i != j {
            if x < a {
                right = i - 1
            } else if x > a {
                left = i + 1
            } else {
                break
            }
            
            j = i
            i = (left + right) / 2

            x = self[i].sortValue
        }

        if x > a {
            i += 1
        } else {
            while i - 1 >= 0 && self[i - 1].sortValue <= a {
                i -= 1
            }
        }
        

        return i
    }
    
    func findRightIndex(value a: Int64) -> Int {
        let n = count
        var left = 0
        var right = n - 1

        var j = -1
        var i = (left + right) / 2
        var x = self[i].sortValue
        
        while i != j {
            if x < a {
                right = i - 1
            } else if x > a {
                left = i + 1
            } else {
                break
            }
            
            j = i
            i = (left + right) / 2

            x = self[i].sortValue
        }
        
        while i + 1 <= n && self[i].sortValue >= a {
            i += 1
        }
        

        return i
    }
}
