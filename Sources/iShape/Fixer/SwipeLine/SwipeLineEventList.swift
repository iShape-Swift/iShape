//
//  SwipeLineEventList.swift
//  
//
//  Created by Nail Sharipov on 18.03.2023.
//

struct SwipeLineEventList {
    
    private var eventQueue: [SwipeLineEvent]
    private var eventMap: [Fixer.Edge: SwipeLineEvent.Action]
    
    @inlinable
    var hasNext: Bool { !eventQueue.isEmpty }
    
    @inlinable
    mutating func next() -> SwipeLineEvent {
        eventQueue.removeLast()
    }
    
    init(contour: IntContour) {
        let edges = contour.edges()
        var result = [SwipeLineEvent]()
        var map = [Fixer.Edge: SwipeLineEvent.Action]()
        let capacity = 2 * (edges.count + 4)
        result.reserveCapacity(capacity)
        map.reserveCapacity(capacity)
        
        // optimise
        
        for i in 0..<edges.count {
            let edge = edges[i]

#if DEBUG
            result.append(SwipeLineEvent(order: edge.start.bitPack, action: .add, edge: edge, point: edge.start))
#else
            result.append(SwipeLineEvent(order: edge.start.bitPack, action: .add, edge: edge))
#endif
            map[edge] = .add
        }
        
        result.sort(by: {
            if $0.order != $1.order {
                return $0.order > $1.order
            } else {
                return $0.edge.end.bitPack > $1.edge.end.bitPack
            }
        })
        
        self.eventQueue = result
        self.eventMap = map
    }
    
    mutating func newAddEvent(edge: Fixer.Edge) {
        
        let order = edge.start.bitPack
        let index = eventQueue.findRightIndex(value: order)
#if DEBUG
        eventQueue.insert(SwipeLineEvent(order: order, action: .add, edge: edge, point: edge.start), at: index)
#else
        eventQueue.insert(SwipeLineEvent(order: order, action: .add, edge: edge), at: index)
#endif
    }

    mutating func newRemoveEvent(edge: Fixer.Edge) {
        let order = edge.end.bitPack
        let index = eventQueue.findLeftIndex(value: order)
#if DEBUG
        eventQueue.insert(SwipeLineEvent(order: order, action: .remove, edge: edge, point: edge.end), at: index)
#else
        eventQueue.insert(SwipeLineEvent(order: order, action: .remove, edge: edge), at: index)
#endif
    }
    
    mutating func deleteRemoveEvent(edge: Fixer.Edge) {
        let order = edge.end.bitPack
        var index = eventQueue.findLeftIndex(value: order)
        while index < eventQueue.count {
            let event = eventQueue[index]
            if event.edge == edge {
                assert(event.action == .remove)
                eventQueue.remove(at: index)
            }
            index += 1
        }
    }
    
}

// Binary search for reversed array
private extension Array where Element == SwipeLineEvent {

    func findLeftIndex(value a: Int64) -> Int {
        var left = 0
        var right = count - 1

        var j = -1
        var i = (left + right) / 2
        var x = self[i].order
        
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

            x = self[i].order
        }

        if x > a {
            i += 1
        } else {
            while i - 1 >= 0 && self[i - 1].order <= a {
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
        var x = self[i].order
        
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

            x = self[i].order
        }
        
        while i + 1 <= n && self[i].order >= a {
            i += 1
        }
        

        return i
    }
}

private extension Array where Element == IntPoint {
    
    func edges() -> [Fixer.Edge] {
        var a = self[count - 1]
        var result = [Fixer.Edge]()
        result.reserveCapacity(count + 4)

        var start = a.bitPack

        for b in self {
            let end = b.bitPack
            
            if start > end {
                result.append(Fixer.Edge(start: b, end: a))
            } else if start < end {
                result.append(Fixer.Edge(start: a, end: b))
            } // skip degenerate dots

            start = end
            a = b
        }
        
        return result
    }
}
