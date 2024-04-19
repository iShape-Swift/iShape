//
//  ShapeAdapter.swift
//
//
//  Created by Nail Sharipov on 14.04.2024.
//

#if canImport(CoreGraphics)

import iFixFloat
import CoreGraphics

public struct PointAdapter {
    
    public let dirScale: CGFloat
    public let invScale: CGFloat
    public let offset: CGPoint
    
    public init(rect: CGRect) {
        let a = rect.width / 2
        let b = rect.height / 2
        
        let ox = rect.origin.x + a
        let oy = rect.origin.y + b
        
        self.offset = CGPoint(x: ox, y: oy)
        
        let e = Int32.bitWidth - 2 - max(a, b).exponent // 2^30 - max(a, b).exponent
        
        self.dirScale = CGFloat(sign: .plus, exponent: e, significand: 1)
        self.invScale = CGFloat(sign: .plus, exponent: -e, significand: 1)
    }
    
    public func convert(point: Point) -> CGPoint {
        let x = CGFloat(point.x) * invScale + offset.x
        let y = CGFloat(point.y) * invScale + offset.y
        return CGPoint(x: x, y: y)
    }
    
    public func convert(point: CGPoint) -> Point {
        let x = Int32((point.x - offset.x) * dirScale)
        let y = Int32((point.y - offset.y) * dirScale)
        return Point(x, y)
    }
}

public extension Array where Element == CGPoint {
    func toPath(adapter: PointAdapter) -> Path {
        self.map({ adapter.convert(point: $0) })
    }
}

public extension CGShape {
    func toShape(adapter: PointAdapter) -> Shape {
        self.map({ $0.toPath(adapter: adapter) })
    }
}

public extension Array where Element == CGShape {
    func toShapes(adapter: PointAdapter) -> [Shape] {
        self.map({ $0.toShape(adapter: adapter) })
    }
}

public extension Path {
    func toCGPath(adapter: PointAdapter) -> [CGPoint] {
        self.map({ adapter.convert(point: $0) })
    }
}

public extension Shape {
    func toCGShape(adapter: PointAdapter) -> CGShape {
        self.map({ $0.toCGPath(adapter: adapter) })
    }
}

public extension Shapes {
    func toCGShapes(adapter: PointAdapter) -> [CGShape] {
        self.map({ $0.toCGShape(adapter: adapter) })
    }
}

public extension CGRect {
    
    init(path: [CGPoint]) {
        guard !path.isEmpty else {
            self = CGRect.zero
            return
        }

        let a = CGFloat.greatestFiniteMagnitude
        var minX = a
        var maxX = -a
        var minY = a
        var maxY = -a

        for p in path {
            minX = min(minX, p.x)
            maxX = max(maxX, p.x)
            minY = min(minY, p.y)
            maxY = max(maxY, p.y)
        }
        
        let width = maxX - minX
        let height = maxY - minY
        
        self = CGRect(x: minX, y: minY, width: width, height: height)
    }
    
    init(shape: CGShape) {
        guard !shape.isEmpty else {
            self = CGRect.zero
            return
        }

        let a = CGFloat.greatestFiniteMagnitude
        var minX = a
        var maxX = -a
        var minY = a
        var maxY = -a

        for path in shape {
            for p in path {
                minX = min(minX, p.x)
                maxX = max(maxX, p.x)
                minY = min(minY, p.y)
                maxY = max(maxY, p.y)
            }
        }
        
        let width = maxX - minX
        let height = maxY - minY
        
        self = CGRect(x: minX, y: minY, width: width, height: height)
    }

    init(shapes: [CGShape]) {
        guard !shapes.isEmpty else {
            self = CGRect.zero
            return
        }
        
        let a = CGFloat.greatestFiniteMagnitude
        var minX = a
        var maxX = -a
        var minY = a
        var maxY = -a

        for shape in shapes {
            for path in shape {
                for p in path {
                    minX = min(minX, p.x)
                    maxX = max(maxX, p.x)
                    minY = min(minY, p.y)
                    maxY = max(maxY, p.y)
                }
            }
        }
        
        let width = maxX - minX
        let height = maxY - minY
        
        self = CGRect(x: minX, y: minY, width: width, height: height)
    }

    init(rect0: CGRect, rect1: CGRect) {
        let minX = min(rect0.minX, rect1.minX)
        let minY = min(rect0.minY, rect1.minY)
        let maxX = min(rect0.maxX, rect1.maxX)
        let maxY = min(rect0.maxY, rect1.maxY)
        
        let width = maxX - minX
        let height = maxY - minY
        
        self = CGRect(x: minX, y: minY, width: width, height: height)
    }
    
}

#endif
