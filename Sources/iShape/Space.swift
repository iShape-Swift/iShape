//
//  Space.swift
//  
//
//  Created by Nail Sharipov on 14.03.2023.
//

import CoreGraphics

public struct Space {

    public static let classic = Space(scale: 1000)
    
    public let scale: Double
    public let iScale: Double

    public static let maxBits = (Int64.bitWidth >> 1) - 1
    public static let max: Int64 = Int64(1) << maxBits
    
    public init(unit: Double) {
        self.scale = 1 / unit
        self.iScale = unit
    }
    
    public init(maxSize: Double) {
        let unit = maxSize / Double(Space.max)
        self.scale = 1 / unit
        self.iScale = unit
    }

    @inlinable
    public init(scale: Double) {
        self.scale = scale
        self.iScale = 1 / scale
    }
    
    @inlinable
    public func int(_ float: Float) -> Int64 {
        let m = Double(float) * scale
        return Int64(m.rounded(.toNearestOrAwayFromZero))
    }
    
    @inlinable
    public func int(_ point: Point) -> IntPoint {
        IntPoint(x: int(point.x), y: int(point.y))
    }
    
    @inlinable
    public func int(_ contour: Contour) -> IntContour {
        let n = contour.count
        var array = Array<IntPoint>(repeating: .zero, count: n)
        for i in 0..<n {
            array[i] = int(contour[i])
        }
        return array
    }
    
    @inlinable
    public func int(_ contours: [Contour]) -> [IntContour] {
        let n = contours.count
        var array = [IntContour]()
        array.reserveCapacity(n)
        for i in 0..<n {
            array.append(int(contours[i]))
        }
        return array
    }
    
    @inlinable
    public func float(_ int: Int64) -> Float {
        Float(Double(int) * iScale)
    }
    
    @inlinable
    public func float(_ point: IntPoint) -> Point {
        Point(x: float(point.x), y: float(point.y))
    }
    
    @inlinable
    public func float(_ contour: IntContour) -> Contour {
        let n = contour.count
        var array = Array<Point>(repeating: .zero, count: n)
        for i in 0..<n {
            array[i] = float(contour[i])
        }
        return array
    }
    
    @inlinable
    public func float(contours: [IntContour]) -> [[Point]] {
        let n = contours.count
        var array = [Contour]()
        array.reserveCapacity(n)
        for i in 0..<n {
            array[i] = float(contours[i])
        }
        return array
    }

}
