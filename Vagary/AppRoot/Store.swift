//
//  Store.swift
//  Vagary
//
//  Created by Jonathan Witten on 10/17/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

class ViaStore {
    
    static let sharedStore = Store(
        reducer: appReducer,
        state: nil
    )
    static var draftCache: Cache? = Cache(path: "drafts")
    
    private let api: TravelApi
    
    
    init() {
        api = TravelApi()
        
    }
    
}

var reducers: [AnySubstateReducer] = [
    AppReducer(),
    FeedReducer(),
    PassportReducer(),
    DraftReducer()
]

func appReducer(action: Action, state: AppState?) -> AppState {
    
    guard let appState = state else {
        return AppState.unauthenticated
    }
    
    for reducer in reducers {
        if let substate = reducer.unwrap(action: action, state: appState) {
            return reducer.reduce(state: appState, action: action, substate: substate)
        }
    }
    
    return appState
    
    
}
