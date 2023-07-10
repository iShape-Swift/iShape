//
//  FixEdge.swift
//  
//
//  Created by Nail Sharipov on 10.07.2023.
//

import iFixFloat

public struct EdgeCross {

    public let type: EdgeCrossType
    public let point: FixVec

    @usableFromInline
    init(type: EdgeCrossType, point: FixVec) {
        self.type = type
        self.point = point
    }
}

public enum EdgeCrossType {
    case not_cross          // no intersections or parallel
    case pure               // simple intersection with no overlaps or common points
    
    case end_a
    case end_b
    
    case common_end
}

public struct FixEdge {

    public static let zero = FixEdge(e0: .zero, e1: .zero)

    // start < end

    public let e0: FixVec  // start
    public let e1: FixVec  // end
    
    public init(e0: FixVec, e1: FixVec) {
        self.e0 = e0
        self.e1 = e1
    }
    
    public func cross(_ other: FixEdge) -> EdgeCross {
        let a0 = e0
        let a1 = e1

        let b0 = other.e0
        let b1 = other.e1
        
        let d0 = Triangle.clockDirection(p0: a0, p1: b0, p2: b1)
        let d1 = Triangle.clockDirection(p0: a1, p1: b0, p2: b1)
        let d2 = Triangle.clockDirection(p0: a0, p1: a1, p2: b0)
        let d3 = Triangle.clockDirection(p0: a0, p1: a1, p2: b1)

        var p: FixVec = .zero
        var type: EdgeCrossType = .not_cross
        
        if d0 == 0 || d1 == 0 || d2 == 0 || d3 == 0 {
            if !(d0 == 0 && d1 == 0 && d2 == 0 && d3 == 0) {
                if d0 == 0 {
                    p = a0
                    if d2 == 0 || d3 == 0 {
                        type = .common_end
                    } else if d2 != d3 {
                        type = .end_a
                    }
                } else if d1 == 0 {
                    p = a1
                    if d2 == 0 || d3 == 0 {
                        type = .common_end
                    } else if d2 != d3 {
                        type = .end_a
                    }
                } else if d0 != d1 {
                    if d2 == 0 {
                        p = b0
                    } else {
                        p = b1
                    }
                    type = .end_b
                }
            }
        } else if d0 != d1 && d2 != d3 {
            p = Self.crossPoint(a0: a0, a1: a1, b0: b0, b1: b1)

            // still can be ends
            let isA0 = a0 == p
            let isA1 = a1 == p
            let isB0 = b0 == p
            let isB1 = b1 == p
            
            if !(isA0 || isA1 || isB0 || isB1) {
                type = .pure
            } else if isA0 && isB0 || isA0 && isB1 || isA1 && isB0 || isA1 && isB1 {
                type = .common_end
            } else if isA0 || isA1 {
                type = .end_a
            } else if isB0 || isB1 {
                type = .end_b
            }
        }

        return EdgeCross(type: type, point: p)
    }
    
    private static func crossPoint(a0: FixVec, a1: FixVec, b0: FixVec, b1: FixVec) -> FixVec {
        let dxA = a0.x - a1.x
        let dyB = b0.y - b1.y
        let dyA = a0.y - a1.y
        let dxB = b0.x - b1.x

        let xyA = a0.x * a1.y - a0.y * a1.x
        let xyB = b0.x * b1.y - b0.y * b1.x
        
        let x = xyA * dxB - dxA * xyB
        let y = xyA * dyB - dyA * xyB

        let divider = dxA * dyB - dyA * dxB
        
        let cx = x / divider
        let cy = y / divider
        
        return FixVec(cx, cy)
    }
}
