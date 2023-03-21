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

    let order: Int64
    let action: Action
    let edge: Fixer.Edge
    
    #if DEBUG
    let point: IntPoint
    #endif
    
}
