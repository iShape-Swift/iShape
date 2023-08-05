//
//  FixEdge.swift
//  
//
//  Created by Nail Sharipov on 10.07.2023.
//

import iFixFloat

public struct EdgeCross {

    static let notCross = EdgeCross(type: .not_cross, point: .zero)
    
    public let type: EdgeCrossType
    public let point: FixVec
    public let second: FixVec

    @usableFromInline
    init(type: EdgeCrossType, point: FixVec, second: FixVec = .zero) {
        self.type = type
        self.point = point
        self.second = second
    }
}

public enum EdgeCrossType {
    
    case not_cross          // no intersections or parallel
    case pure               // simple intersection with no overlaps or common points
    
    case overlay_a          // a is inside b
    case overlay_b          // b is inside a
    case penetrate          // a and b penetrate each other
    case end_a
    case end_b
}

public struct FixEdge {

    public static let zero = FixEdge(e0: .zero, e1: .zero)

    public let e0: FixVec
    public let e1: FixVec
    
    public init(e0: FixVec, e1: FixVec) {
        self.e0 = e0
        self.e1 = e1
    }

    public func cross(_ other: FixEdge) -> EdgeCross {

        let a0 = e0
        let a1 = e1

        let b0 = other.e0
        let b1 = other.e1

        let a0Area = Triangle.unsafeArea(p0: b0, p1: a0, p2: b1)
        let a1Area = Triangle.unsafeArea(p0: b0, p1: a1, p2: b1)
        
        let comA0 = a0 == b0 || a0 == b1
        let comA1 = a1 == b0 || a1 == b1
        
        guard a0Area != 0 || a1Area != 0 else {
            // same line
            return Self.sameLineOverlay(self, other)
        }
        
        let hasSameEnd = comA0 || comA1
        
        guard !hasSameEnd else {
            return .notCross
        }

        guard a0Area != 0 else {
            if other.isBoxContain(a0) {
                return EdgeCross(type: .end_a, point: a0)
            } else {
                return .notCross
            }
        }

        guard a1Area != 0 else {
            if other.isBoxContain(a1) {
                return EdgeCross(type: .end_a, point: a1)
            } else {
                return .notCross
            }
        }

        let b0Area = Triangle.unsafeArea(p0: a0, p1: b0, p2: a1)

        guard b0Area != 0 else {
            if self.isBoxContain(b0) {
                return EdgeCross(type: .end_b, point: b0)
            } else {
                return .notCross
            }
        }

        let b1Area = Triangle.unsafeArea(p0: a0, p1: b1, p2: a1)

        guard b1Area != 0 else {
            if self.isBoxContain(b1) {
                return EdgeCross(type: .end_b, point: b1)
            } else {
                return .notCross
            }
        }

        // areas of triangles must have opposite sign
        let areaACondition = a0Area > 0 && a1Area < 0 || a0Area < 0 && a1Area > 0
        let areaBCondition = b0Area > 0 && b1Area < 0 || b0Area < 0 && b1Area > 0

        guard areaACondition && areaBCondition else {
            return .notCross
        }

        let p = Self.crossPoint(a0: a0, a1: a1, b0: b0, b1: b1)

        // still can be common ends cause rounding
        let endA = a0 == p || a1 == p
        let endB = b0 == p || b1 == p

        var type: EdgeCrossType = .not_cross

        if !endA && !endB {
            type = .pure
        } else if endA {
            type = .end_a
        } else if endB {
            type = .end_b
        } else {
            assertionFailure("impossible")
        }

        return EdgeCross(type: type, point: p)
    }

    private static func crossPoint(a0: FixVec, a1: FixVec, b0: FixVec, b1: FixVec) -> FixVec {
        
        let vA = a0 - a1
        let vB = b0 - b1

        let crossA = a0.unsafeCrossProduct(a1)
        let crossB = b0.unsafeCrossProduct(b1)
        
        let x = crossA * vB.x - vA.x * crossB
        let y = crossA * vB.y - vA.y * crossB

        let divider = vA.unsafeCrossProduct(vB)
        
        let cx = x / divider
        let cy = y / divider
        
        return FixVec(cx, cy)
    }

    private func isBoxContain(_ p: FixVec) -> Bool {
        let xCondition = e0.x <= p.x && p.x <= e1.x || e1.x <= p.x && p.x <= e0.x
        let yCondition = e0.y <= p.y && p.y <= e1.y || e1.y <= p.y && p.y <= e0.y
        return xCondition && yCondition
    }
    
    private static func sameLineOverlay(_ edgeA: FixEdge, _ edgeB: FixEdge) -> EdgeCross {
        let a = FixBnd(edge: edgeA)
        let b = FixBnd(edge: edgeB)

        let isCollide = a.isCollide(b)

        guard isCollide else {
            return .notCross
        }

        let isA = a.isInside(b) // b inside a
        let isB = b.isInside(a) // a inside b
        
        guard !(isA && isB) else {
            // edges are equal
            return .notCross
        }
        
        if isA {
            // b inside a
            
            let isBe0 = edgeB.e0 == edgeA.e0 || edgeB.e0 == edgeA.e1
            let isBe1 = edgeB.e1 == edgeA.e0 || edgeB.e1 == edgeA.e1

            if isBe0 {
                // first point is common
                return EdgeCross(type: .end_b, point: edgeB.e1)
            } else if isBe1 {
                // second point is common
                return EdgeCross(type: .end_b, point: edgeB.e0)
            } else {
                // no common points
                return EdgeCross(type: .overlay_b, point: .zero)
            }
        }
        
        if isB {
            // a inside b

            let isAe0 = edgeA.e0 == edgeB.e0 || edgeA.e0 == edgeB.e1
            let isAe1 = edgeA.e1 == edgeB.e0 || edgeA.e1 == edgeB.e1
            
            if isAe0 {
                // first point is common
                return EdgeCross(type: .end_a, point: edgeA.e1)
            } else if isAe1 {
                // second point is common
                return EdgeCross(type: .end_a, point: edgeA.e0)
            } else {
                // no common points
                return EdgeCross(type: .overlay_a, point: .zero)
            }
        }
        
        let hasSameEnd = edgeA.e0 == edgeB.e0 || edgeA.e0 == edgeB.e1 || edgeA.e1 == edgeB.e0 || edgeA.e1 == edgeB.e1
        
        guard !hasSameEnd else {
            return .notCross
        }
        
        // penetrate
        
        let ap = a.isContain(point: edgeB.e0) ? edgeB.e0 : edgeB.e1
        let bp = b.isContain(point: edgeA.e0) ? edgeA.e0 : edgeA.e1
        
        return EdgeCross(type: .penetrate, point: ap, second: bp)
    }

}


private extension FixBnd {

    init(edge: FixEdge) {
        self.init(p0: edge.e0, p1: edge.e1)
    }

}
