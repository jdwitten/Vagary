//
//  Reducer.swift
//  Vagary
//
//  Created by Jonathan Witten on 8/15/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

struct AppReducer: SubstateReducer {
    
    typealias SubstateType = AppState
    typealias ActionType = AppAction
    func unwrap(action: Action, state: AppState) -> StateType? {
        return nil
    }
    
    func wrap(substate: AppState, appState: AppState) -> AppState {
        return appState
    }
    
    func reduce(action: AppAction, substate: AppState) -> AppState {
        return substate
    }
}
