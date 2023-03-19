//
//  SwipeLineEvent.swift
//  
//
//  Created by Nail Sharipov on 17.03.2023.
//

@usableFromInline
struct SwipeLineEvent {

    enum Action: Int {
        case add = 0
        case remove = 1
    }

    @usableFromInline
    let sortValue: Int64
    let action: Action
    let edgeId: Int
    
    #if DEBUG
    let point: IntPoint
    #endif
    
}
