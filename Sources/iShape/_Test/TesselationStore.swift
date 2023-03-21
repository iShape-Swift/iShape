//
//  TesselationStore.swift
//  
//
//  Created by Nail Sharipov on 20.03.2023.
//

public struct TesselationTest {
    
    public let id: Int
    public let shape: IntShape
}

public struct TesselationStore {
    
    public static let tests: [TesselationTest] = [
        TesselationTest(
            id: 0,
            shape: IntShape(contour: IntContour([
                Point(x: -20, y:-20),
                Point(x: -20, y: 20),
                Point(x:  20, y: 20),
                Point(x:  20, y:-20)
        ]))),
    ]
}
