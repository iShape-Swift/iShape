//
// Created by Nail Sharipov on 03.08.2023.
//

import iFixFloat

public typealias FixPaths = [FixPath]

public extension FixPaths {

    func findMaxAreaPath() -> FixPath {
        var i = 0
        var maxIndex = 0
        var maxArea: FixFloat = 0

        while i < count {
            let area = self[i].area
            if abs(maxArea) < abs(area) {
                maxArea = area
                maxIndex = i
            }
            i += 1
        }

        if maxArea < 0 {
            return self[maxIndex].reversed()
        } else {
            return self[maxIndex]
        }
    }
}