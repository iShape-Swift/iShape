//
//  FixBnd.swift
//  
//
//  Created by Nail Sharipov on 10.07.2023.
//

import iFixFloat

public struct FixBnd: Equatable {

    public static let zero = FixBnd(min: .zero, max: .zero)
    
    public let min: FixVec
    public let max: FixVec
    
    @inline(__always)
    public var center: FixVec { (min + max).half }
    
    @inline(__always)
    public init(min: FixVec, max: FixVec) {
        self.min = min
        self.max = max
    }

    @inline(__always)
    public init(radius: FixFloat) {
        self.min = FixVec(-radius, -radius)
        self.max = FixVec(radius, radius)
    }
    
    @inline(__always)
    public init(p0: FixVec, p1: FixVec) {
        let minX: Int64
        let maxX: Int64
        if p0.x < p1.x {
            minX = p0.x
            maxX = p1.x
        } else {
            minX = p1.x
            maxX = p0.x
        }

        let minY: Int64
        let maxY: Int64
        if p0.y < p1.y {
            minY = p0.y
            maxY = p1.y
        } else {
            minY = p1.y
            maxY = p0.y
        }
        
        self.min = FixVec(minX, minY)
        self.max = FixVec(maxX, maxY)
    }

    @inline(__always)
    public init(points: [FixVec]) {
        let p0 = points[0]
        var minX = p0.x
        var maxX = p0.x
        var minY = p0.y
        var maxY = p0.y

        for i in 1..<points.count {
            let p = points[i]

            minX = Swift.min(minX, p.x)
            maxX = Swift.max(maxX, p.x)
            minY = Swift.min(minY, p.y)
            maxY = Swift.max(maxY, p.y)
        }
        
        self.min = FixVec(minX, minY)
        self.max = FixVec(maxX, maxY)
    }

    @inline(__always)
    public func union(_ b: FixBnd) -> FixBnd {
        let minX = Swift.min(min.x, b.min.x)
        let minY = Swift.min(min.y, b.min.y)
        let maxX = Swift.max(max.x, b.max.x)
        let maxY = Swift.max(max.y, b.max.y)
        
        return FixBnd(min: FixVec(minX, minY), max: FixVec(maxX, maxY))
    }
    
    @inline(__always)
    public func isCollide(_ b: FixBnd) -> Bool {
        // Check if the bounding boxes intersect in any dimension
        if max.x < b.min.x || min.x > b.max.x {
            return false
        }
        
        if max.y < b.min.y || min.y > b.max.y {
            return false
        }
        
        return true
    }

    @inline(__always)
    public func isInside(_ b: FixBnd) -> Bool {
        let isX = max.x >= b.max.x && min.x <= b.min.x
        let isY = max.y >= b.max.y && min.y <= b.min.y
        return isX && isY
    }
    
    @inline(__always)
    public func isContain(point p: FixVec) -> Bool {
        min.x <= p.x && p.x <= max.x && min.y <= p.y && p.y <= max.y
    }

    @inline(__always)
    public func isCollideCircle(center: FixVec, radius: FixFloat) -> Bool {
        let cx = Swift.max(min.x, Swift.min(center.x, max.x))
        let cy = Swift.max(min.y, Swift.min(center.y, max.y))

        let sqrDist = FixVec(cx, cy).fixSqrDistance(center)

        return sqrDist <= radius.fixSqr
    }
    
    @inline(__always)
    public func isOverlap(_ b: FixBnd) -> Bool {
        min.x - 1 < b.min.x && min.y - 1 < b.min.y && max.x + 1 > b.max.x && max.y + 1 > b.max.y
    }

}
