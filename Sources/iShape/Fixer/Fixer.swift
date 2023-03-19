//
//  Fixer.swift
//  
//
//  Created by Nail Sharipov on 09.11.2022.
//


public extension IntContour {
    
    func fix(clockWise: Bool = true) -> [IntContour] {
        Fixer().solve(contour: self)
    }
    
}

struct Fixer {
    
    @inlinable
    func solve(contour: IntContour, clockWise: Bool = true) -> [IntContour] {
        let edges = self.devide(contour: contour)

        let list = Linker(edges: edges).join()
        
        var result = [[IntPoint]]()
        result.reserveCapacity(list.count)
        
        for var points in list {
            if !points.isEmpty {
                if !clockWise {
                    points.reverse()
                }
                result.append(points)
            }
        }

        return result
    }
    
    private func devide(contour: IntContour) -> [Edge] {
        var edges = contour.edges()
        
        var eventList = SwipeLineEventList(edges: edges)
        
        var scanList = [Int]()
        scanList.reserveCapacity(16)

        while eventList.hasNext {
            let event = eventList.next()

            switch event.action {
            case .add:
                
                var thisId = event.edgeId
                var thisEdge = edges[thisId]
                var newScanId = thisId
                
                // try to cross with the scan list
                var j = 0
                while j < scanList.count {
                    let otherId = scanList[j]
                    let otherEdge = edges[otherId]
                    let crossResult = thisEdge.cross(other: otherEdge)
                    
                    switch crossResult.type {
                    case .not_cross, .end_a0_b0, .end_a0_b1, .end_a1_b0, .end_a1_b1, .same_line:
                        j += 1
                    case .pure:
                        let cross = crossResult.point

                        // devide edges
                        
                        // for this edge
                        // create new left part (new edge id), put 'remove' event
                        // update right part (keep old edge id), put 'add' event
                        
                        let thisNewId = edges.count
                        let thisResult = self.devide(edge: thisEdge, id: thisId, cross: cross, nextId: thisNewId)
                        
                        edges.append(thisResult.leftPart)
                        thisEdge = thisResult.leftPart
                        edges[thisId] = thisResult.rightPart    // update old edge (right part)
                        thisId = thisNewId                      // we are now left part with new id

                        newScanId = thisNewId
                        
                        // for other(scan) edge
                        // create new left part (new edge id), put 'remove' event
                        // update right part (keep old edge id), put 'add' event
                        
                        let otherNewId = edges.count
                        let otherResult = self.devide(edge: otherEdge, id: otherId, cross: cross, nextId: otherNewId)
                        
                        edges.append(otherResult.leftPart)
                        edges[otherId] = otherResult.rightPart

                        scanList[j] = otherNewId
                        
                        // insert events
                        
                        eventList.add(event: thisResult.removeEvent)
                        eventList.add(event: otherResult.removeEvent)
                        eventList.add(event: thisResult.addEvent)
                        eventList.add(event: otherResult.addEvent)

                        j += 1
                    case .end_b0, .end_b1:
                        let cross = crossResult.point
                        
                        // devide this edge
                        
                        // create new left part (new edge id), put 'remove' event
                        // update right part (keep old edge id), put 'add' event
                        
                        let thisNewId = edges.count
                        let thisResult = self.devide(edge: thisEdge, id: thisId, cross: cross, nextId: thisNewId)
                        
                        thisEdge = thisResult.leftPart
                        edges.append(thisResult.leftPart)
                        edges[thisId] = thisResult.rightPart    // update old edge (right part)
                        thisId = thisNewId                      // we are now left part with new id
                        
                        newScanId = thisNewId
                        
                        // insert events

                        eventList.add(event: thisResult.removeEvent)
                        eventList.add(event: thisResult.addEvent)

                        j += 1
                    case .end_a0, .end_a1:
                        let cross = crossResult.point
                        
                        // devide other(scan) edge

                        // create new left part (new edge id), put 'remove' event
                        // update right part (keep old edge id), put 'add' event

                        let otherNewId = edges.count
                        let otherResult = self.devide(edge: otherEdge, id: otherId, cross: cross, nextId: otherNewId)
                        
                        edges.append(otherResult.leftPart)
                        edges[otherId] = otherResult.rightPart
                        
                        scanList[j] = otherNewId
                        
                        // insert events

                        eventList.add(event: otherResult.removeEvent)
                        eventList.add(event: otherResult.addEvent)
                        
                        j += 1
                    }
                } // while scanList
                
                scanList.append(newScanId)

            case .remove:
                // scan list is sorted
                print(event)
                if let index = scanList.firstIndex(of: event.edgeId) { // it must be one of the first elements
                    scanList.remove(at: index)
                } else {
                    assertionFailure("impossible")
                }
            } // switch
            
            #if DEBUG
            let set = Set(scanList)
            assert(set.count == scanList.count)
            #endif

        } // while
        
        return edges
    }
    
    private struct DivideResult {
        let leftPart: Fixer.Edge
        let rightPart: Fixer.Edge
        let removeEvent: SwipeLineEvent
        let addEvent: SwipeLineEvent
    }
    
    private func devide(edge: Fixer.Edge, id: Int, cross: IntPoint, nextId: Int) -> DivideResult {
        let leftPart = Fixer.Edge(start: edge.start, end: cross)
        let rightPart = Fixer.Edge(start: cross, end: edge.end)

#if DEBUG
        // left
        let evRemove = SwipeLineEvent(sortValue: leftPart.end.bitPack, action: .remove, edgeId: nextId, point: leftPart.end)
        // right
        let evAdd = SwipeLineEvent(sortValue: rightPart.start.bitPack, action: .add, edgeId: id, point: cross)
#else
        let evRemove = SwipeLineEvent(sortValue: bitPack, action: .remove, edgeId: nextId)
        let evAdd = SwipeLineEvent(sortValue: bitPack, action: .add, edgeId: id)
#endif
        
        return DivideResult(
            leftPart: leftPart,
            rightPart: rightPart,
            removeEvent: evRemove,
            addEvent: evAdd
        )
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
