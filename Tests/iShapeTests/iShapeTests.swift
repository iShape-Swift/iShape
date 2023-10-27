import XCTest
import iFixFloat
@testable import iShape

final class iShapeTests: XCTestCase {

    // Existing test
    func test_convex_00() throws {
        let path = [FixVec(-10, -10), FixVec(-10, 10), FixVec(10, 10), FixVec(10, -10)]
        XCTAssertTrue(path.isConvex)
        XCTAssertTrue(Array(path.reversed()).isConvex)
    }
    
    // Test for a simple non-convex quadrilateral
    func test_nonConvex_01() throws {
        let path = [FixVec(-10, -10), FixVec(0, 10), FixVec(10, -10), FixVec(0, -5)]
        XCTAssertFalse(path.isConvex)
    }
    
    // Test for a convex pentagon
    func test_convex_02() throws {
        let path = [FixVec(0, 0), FixVec(1, 2), FixVec(3, 3), FixVec(4, 1), FixVec(2, 0)]
        XCTAssertTrue(path.isConvex)
    }
    
    // Test for a non-convex pentagon
    func test_nonConvex_03() throws {
        let path = [FixVec(0, 0), FixVec(1, 2), FixVec(0, 4), FixVec(4, 2), FixVec(2, 0)]
        XCTAssertFalse(path.isConvex)
    }
    
    // Test for a path with fewer than 3 points
    func test_fewPoints_04() throws {
        let path1: [FixVec] = []
        XCTAssertTrue(path1.isConvex)
        
        let path2 = [FixVec(0, 0)]
        XCTAssertTrue(path2.isConvex)
        
        let path3 = [FixVec(0, 0), FixVec(1, 1)]
        XCTAssertTrue(path3.isConvex)
    }

    // Test for a concave hexagon
    func test_convex_05() throws {
        let path = [FixVec(0, 0), FixVec(1, 2), FixVec(2, 3), FixVec(3, 2), FixVec(4, 1), FixVec(2, 0)]
        XCTAssertTrue(path.isConvex)
    }
    
    // Test for a concave hexagon
    func test_convex_06() throws {
        let path = [
            FixVec(-10, -10),
            FixVec(-10,   0),
            FixVec(-10,  10),
            FixVec(  0,  10),
            FixVec( 10,  10),
            FixVec( 10,   0),
            FixVec( 10, -10),
            FixVec(  0, -10),
        ]
        XCTAssertTrue(path.isConvex)
        XCTAssertTrue(Array(path.reversed()).isConvex)
    }
    
    // Test for a concave hexagon
    func test_convex_07() throws {
        let path = [
            FixVec(-10, -10),
            FixVec(-9,   0),
            FixVec(-10,  10),
            FixVec(  0,  10),
            FixVec( 10,  10),
            FixVec( 10,   0),
            FixVec( 10, -10),
            FixVec(  0, -10),
        ]
        XCTAssertFalse(path.isConvex)
        XCTAssertFalse(Array(path.reversed()).isConvex)
    }
}
