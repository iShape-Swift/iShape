//
//  IntShape+Init.swift
//  
//
//  Created by Nail Sharipov on 17.03.2023.
//


extension IntShape {

    init(contours: [Contour]) {
        var list = contours
        let hull = list.removeFirst()
        let iHull = Space.classic.int(hull)
        let iHoles = Space.classic.int(list)
        self.init(contour: iHull, holes: iHoles)
    }

}
