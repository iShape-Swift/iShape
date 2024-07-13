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
        
        let e = 29 - max(a, b).exponent // 2^29 - max(a, b).exponent
        
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
    
    init?(path: [CGPoint]) {
        guard let p0 = path.first else {
            return nil
        }

        var minX = p0.x
        var maxX = p0.x
        var minY = p0.y
        var maxY = p0.y

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
    
    init?(shape: CGShape) {
        guard let p0 = shape.firstPoint else {
            return nil
        }

        var minX = p0.x
        var maxX = p0.x
        var minY = p0.y
        var maxY = p0.y

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

    init?(shapes: [CGShape]) {
        guard let p0 = shapes.firstPoint else {
            return nil
        }
        
        var minX = p0.x
        var maxX = p0.x
        var minY = p0.y
        var maxY = p0.y

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
        let maxX = max(rect0.maxX, rect1.maxX)
        let maxY = max(rect0.maxY, rect1.maxY)
        
        let width = maxX - minX
        let height = maxY - minY
        
        self = CGRect(x: minX, y: minY, width: width, height: height)
    }
    
    init?(rect0: CGRect?, rect1: CGRect?) {
        let unionRect: CGRect
        if let rect0 = rect0, let rect1 = rect1 {
            self = CGRect(rect0: rect0, rect1: rect1)
        } else if let rect = rect0 {
            self = rect
        } else if let rect = rect1 {
            self = rect
        } else {
            return nil
        }
    }
}

private extension CGShape {
    var firstPoint: CGPoint? {
        for path in self {
            if let p = path.first {
                return p
            }
        }
        return nil
    }
}

private extension CGShapes {
    var firstPoint: CGPoint? {
        for shape in self {
            if let p = shape.firstPoint {
                return p
            }
        }
        return nil
    }
}
#endif
