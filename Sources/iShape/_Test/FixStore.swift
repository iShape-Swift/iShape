//
//  FixStore.swift
//  
//
//  Created by Nail Sharipov on 17.03.2023.
//

public struct FixTest {
    
    public let id: Int
    public let contour: IntContour
}

public struct FixStore {
    
    public static let tests: [FixTest] = [
        FixTest(
            id: 0,
            contour: IntContour([
                Point(x: -15, y: 0),
                Point(x: -15, y: 10),
                Point(x: -5, y: 10),
                Point(x: -5, y: 0),
                Point(x: 5, y: 0),
                Point(x: 5, y: 10),
                Point(x: 15, y: 10),
                Point(x: 15, y: 0)
        ])),
        FixTest(
            id: 1,
            contour: IntContour([
                Point(x: -10, y: 0),
                Point(x: -10, y: 10),
                Point(x: 0, y: 10),
                Point(x: 0, y: -10),
                Point(x: 10, y: -10),
                Point(x: 10, y: 0)
        ])),
        FixTest(
            id: 2,
            contour: IntContour([
                IntPoint(x: -15000, y: 0),
                IntPoint(x: -15000, y: 10000),
                IntPoint(x: -5000, y: 10000),
                IntPoint(x: -4918, y: -57),
                IntPoint(x: 5000, y: 0),
                IntPoint(x: 5000, y: 10000),
                IntPoint(x: 15000, y: 10000),
                IntPoint(x: 15000, y: 0)
        ]))
    ]
}
