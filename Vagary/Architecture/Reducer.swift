//
//  Reducer.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/7/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

protocol AnySubstateReducer {
    func reduce(state: AppState, action: Action, substate: Any) -> AppState
    func unwrap(action: Action, state: AppState) -> AppState?
}

protocol SubstateReducer: AnySubstateReducer {
    associatedtype ActionType
    associatedtype SubstateType
    func wrap(substate: SubstateType, appState: AppState) -> AppState
    func reduce(action: ActionType, substate: SubstateType) -> SubstateType
}

extension SubstateReducer {
    func reduce(state: AppState, action: Action, substate: Any) -> AppState {
        return wrap(substate: reduce(action: action as! ActionType,
                                     substate: substate as! SubstateType),
                    appState: state)
    }
}
