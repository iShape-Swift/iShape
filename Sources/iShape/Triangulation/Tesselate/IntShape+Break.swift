//
//  IntShape+Break.swift
//  
//
//  Created by Nail Sharipov on 21.03.2023.
//

public extension IntShape {
    
    func split(maxEdge: Float, factor: Float, space: Space) -> Delaunay {
        var iShape = self
        iShape.divide(maxEdge: maxEdge, space: space)
        var delaunay = iShape.delaunay()
        
        let maxArea = factor * maxEdge * maxEdge
        
        delaunay.tessellate(maxArea: maxArea, space: space)
        
        return delaunay
    }
    
}
