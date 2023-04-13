//
//  Morph.swift
//  
//
//  Created by Nail Sharipov on 21.03.2023.
//

import simd

public struct Morph {

    public static func roundCorner(_ a: Point, _ b: Point, _ c: Point, radius r: Float, ratio: Float) -> [Point] {
        let v0 = Vector(a: a, b: b)
        let v1 = Vector(a: b, b: c)
        return roundCorner(v0, v1, radius: r, ratio: ratio)
    }
    
    static func roundCorner(_ v0: Vector, _ v1: Vector, radius: Float, ratio: Float) -> [Point] {
        let vr0 = 0.45 * v0.length
        let vr1 = 0.45 * v1.length
        let vr = min(vr0, vr1)
        
        let r = min(radius, vr)
        
        let cs = v0.unit.dotProduct(v1.unit)
        guard cs < 0.999 else {
            return [v0.b]
        }
        
        let minStep = ratio * radius
        let angle = acos(cs)
        
        let s = angle * r
        
        guard minStep < s else {
            return [v0.b]
        }
        
        let n = Int(s / minStep + 0.99)

        var result = [Point]()
        result.reserveCapacity(n + 1)
        
        var da = angle / Float(n)
        
        if v0.unit.crossProduct(v1.unit) > 0 {
            da = -angle / Float(n)
        }

        let cc = cornerCenter(v0, v1, radius: r)

        result.append(cc.a)
        

        var vec = cc.a - cc.m
        let rotMat = Mat2d(angle: da)

        for _ in 1..<n {
            vec = simd_mul(rotMat, vec)
            let p = cc.m + vec
            result.append(p)
        }
        
        result.append(cc.b)
        
        return result
    }
    
    public static func cornerCenter(_ a: Point, _ b: Point, _ c: Point, radius r: Float) -> Point {
        let v0 = Vector(a: a, b: b)
        let v1 = Vector(a: b, b: c)
        return cornerCenter(v0, v1, radius: r).m
    }

    private struct CornerCenter {
        let a: Point
        let b: Point
        let m: Point
    }
    
    private static func cornerCenter(_ v0: Vector, _ v1: Vector, radius r: Float) -> CornerCenter {
        let nA = Point(x: -v0.unit.y, y: v0.unit.x)
        let nB = Point(x: -v1.unit.y, y: v1.unit.x)

        let a0 = v0.b - v0.unit * r
        let b0 = v0.b + v1.unit * r
        
        let dx = nA.x - nB.x
        let dy = nA.y - nB.y
        
        let R: Float
        
        if abs(dx) > abs(dy) {
            R = (b0.x - a0.x) / dx
        } else {
            R = (b0.y - a0.y) / dy
        }
        
        let m = a0 + R * nA

        return CornerCenter(a: a0, b: b0, m: m)
    }
    
}
