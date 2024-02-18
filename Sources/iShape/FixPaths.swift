//
// Created by Nail Sharipov on 03.08.2023.
//

import iFixFloat

public typealias FixPaths = [FixPath]

public extension FixPaths {

    var pointsCount: Int {
        self.reduce(0, { $0 + $1.count })
    }
}
