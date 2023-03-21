//
//  IntPoint.swift
//  
//
//  Created by Nail Sharipov on 14.03.2023.
//

public struct IntPoint {
    
    public static let zero = IntPoint(x: 0, y: 0)
    
    public var x: Int64
    public var y: Int64

    #if DEBUG
    public let deb_x: Float
    public let deb_y: Float
    #endif
    
    @inlinable
    public var bitPack: Int64 {
        (x << Space.maxBits) + y
    }
    
    @inlinable
    public init(x: Int64, y: Int64) {
        self.x = x
        self.y = y
#if DEBUG
        deb_x = Float(x / 1000)
        deb_y = Float(y / 1000)
#endif
    }
    
    @inlinable
    public static func +(left: IntPoint, right: IntPoint) -> IntPoint {
        IntPoint(x: left.x + right.x, y: left.y + right.y)
    }

    @inlinable
    public static func -(left: IntPoint, right: IntPoint) -> IntPoint {
        IntPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    @inlinable
    public func dotProduct(_ point: IntPoint) -> Int64 { // dot product (cos)
        self.x * point.x + point.y * self.y
    }
    
    @inlinable
    public func crossProduct(_ point: IntPoint) -> Int64 { // cross product
        self.x * point.y - self.y * point.x
    }
    
    @inlinable
    public func normal(space: Space) -> IntPoint {
        let p = space.float(self)
        let l = (p.x * p.x + p.y * p.y).squareRoot()
        let k = 1 / l
        let x = k * p.x
        let y = k * p.y
        
        return space.int(Point(x: x, y: y))
    }
    
    @inlinable
    public func sqrDistance(point: IntPoint) -> Int64 {
        let dx = point.x - self.x
        let dy = point.y - self.y

        return dx * dx + dy * dy
    }
    
    @inlinable
    public func sqrLength() -> Int64 {
        x * x + y * y
    }
    
    @inlinable
    public static func isSameLine(a: IntPoint, b: IntPoint, c: IntPoint) -> Bool {
        let dxBA = b.x - a.x
        let dxCA = c.x - a.x
        
        if dxBA == 0 && dxCA == 0 {
            return true
        }

        let dyBA = b.y - a.y
        let dyCA = c.y - a.y
        
        if dyBA == 0 && dyCA == 0 {
            return true
        }
        
        let kBA = Double(dxBA) / Double(dyBA)
        let kCA = Double(dxCA) / Double(dyCA)
        
        let dif = abs(kBA - kCA)
        
        return dif < 0.000_000_000_000_000_0001
    }
    
}

extension IntPoint: Equatable {
    @inlinable
    public static func == (lhs: IntPoint, rhs: IntPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

#if DEBUG
extension IntPoint: CustomStringConvertible {
    
    public var description: String {
        return "(\(deb_x), \(deb_y))"
    }
    
}
#endif
