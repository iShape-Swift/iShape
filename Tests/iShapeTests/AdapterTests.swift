//
//  AdapterTests.swift
//
//
//  Created by Nail Sharipov on 19.04.2024.
//

import XCTest
import iFixFloat
@testable import iShape

class AdapterTests: XCTestCase {
    
    func test_0() throws {
        let aRect = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 1, y: 0)
            ]
        let adapter = PointAdapter(rect: CGRect(path: aRect))

        let iRect = aRect.toPath(adapter: adapter)
        let bRect = iRect.toCGPath(adapter: adapter)

        XCTAssertEqual(aRect, bRect)
        
        let a: Int32 = 1 << 30
        let jRect = [
            Point(-a, -a),
            Point(-a, a),
            Point(a, a),
            Point(a, -a)
        ]
        
        XCTAssertEqual(iRect, jRect)
    }
    
    func test_1() throws {
        let aRect = [
            CGPoint(x: -1, y: -1),
            CGPoint(x: -1, y: 1),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 1, y: -1)
            ]
        let adapter = PointAdapter(rect: CGRect(path: aRect))

        let iRect = aRect.toPath(adapter: adapter)
        let bRect = iRect.toCGPath(adapter: adapter)

        XCTAssertEqual(aRect, bRect)
        
        let a: Int32 = 1 << 30
        let jRect = [
            Point(-a, -a),
            Point(-a, a),
            Point(a, a),
            Point(a, -a)
        ]
        
        XCTAssertEqual(iRect, jRect)
    }
    
}
