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
        var eventList = SwipeLineEventList(contour: contour)
        
        var scanSet = Set<Edge>()
        scanSet.reserveCapacity(16)

        var edges = [Edge]()
        edges.reserveCapacity((contour.count * 4) / 3)
        
        while eventList.hasNext {
            let event = eventList.next()

            switch event.action {
            case .add:
                
                var this = event.edge

                let scanList = Array(scanSet)
                
                for other in scanList {
                    let crossResult = this.cross(other: other)
                    
                    switch crossResult.type {
                    case .not_cross, .end_a0_b0, .end_a0_b1, .end_a1_b0, .end_a1_b1, .same_line:
                        continue
                    case .pure:
                        let cross = crossResult.point

                        assert(scanSet.contains(other))
                        scanSet.remove(other)
                        eventList.deleteRemoveEvent(edge: other)
                        
                        // devide this and other

                        let thisParts = self.devide(edge: this, cross: cross)
                        let otherParts = self.devide(edge: other, cross: cross)
                        
                        assert(!scanSet.contains(otherParts.left))
                        scanSet.insert(otherParts.left)
                        eventList.newRemoveEvent(edge: otherParts.left)
                        
                        eventList.newAddEvent(edge: thisParts.right)
                        eventList.newAddEvent(edge: otherParts.right)
                        
                        this = thisParts.left
                        
                    case .end_b0, .end_b1:
                        let cross = crossResult.point
                        
                        // devide this

                        let thisParts = self.devide(edge: this, cross: cross)

                        eventList.newAddEvent(edge: thisParts.right)
                        
                        this = thisParts.left
                        
                    case .end_a0, .end_a1:
                        let cross = crossResult.point
                        
                        assert(scanSet.contains(other))
                        scanSet.remove(other)
                        eventList.deleteRemoveEvent(edge: other)
                        
                        // devide other

                        let otherParts = self.devide(edge: other, cross: cross)
                        
                        assert(!scanSet.contains(otherParts.left))
                        scanSet.insert(otherParts.left)
                        eventList.newRemoveEvent(edge: otherParts.left)
                        
                        eventList.newAddEvent(edge: otherParts.right)
                    }
                } // while scanList
                
                scanSet.insert(this)
                eventList.newRemoveEvent(edge: this)

            case .remove:
                assert(scanSet.contains(event.edge))
                edges.append(event.edge)
                scanSet.remove(event.edge)
            } // switch
        } // while
        
        return edges
    }
    
    private struct DivideResult {
        let left: Fixer.Edge
        let right: Fixer.Edge
    }
    
    private func devide(edge: Fixer.Edge, cross: IntPoint) -> DivideResult {
        let leftPart = Fixer.Edge(start: edge.start, end: cross)
        let rightPart = Fixer.Edge(start: cross, end: edge.end)
        
        return DivideResult(left: leftPart, right: rightPart)
    }
}
