//
//  DraftState.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/9/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

struct DraftState: StateType {
    var workingPost: Draft?
    var drafts: Loaded<[Draft]> = .loading
}

enum DraftAction: Action {
    case updateDraft(Draft)
    case loadedDrafts(Loaded<[Draft]>)
    case setContent([PostElement])
    case appendDraftElement(PostElement)
    case updateElement(PostElement, Int)
    case setCoverImage(DraftImage)
}

struct DraftReducer: SubstateReducer {
    
    typealias ActionType = DraftAction
    
    typealias SubstateType = DraftState
    
    func unwrap(action: Action, state: AppState) -> StateType? {
        if action is DraftAction {
            return state.authenticatedState?.draft
        } else {
            return nil
        }
    }
    
    func wrap(substate: DraftState, appState: AppState) -> AppState {
        if let authState = appState.authenticatedState {
            return AppState.authenticated(AuthenticatedState(auth: authState.auth, feed: authState.feed, passport: authState.passport, draft: substate))
        } else {
            return AppState.unauthenticated
        }
    }
    
    func reduce(action: DraftAction, substate: DraftState) -> DraftState {
        var newState = substate
        switch action {
        case .updateDraft(let draft):
            newState.workingPost = draft
        case .loadedDrafts(let drafts):
            newState.drafts = drafts
        case .setContent(let content):
            newState.workingPost?.content = content
        case .appendDraftElement(let element):
            newState.workingPost?.content?.append(element)
        case .updateElement(let element, let index):
            if newState.workingPost?.content?.count ?? 0 > index {
                newState.workingPost?.content?[index] = element
            }
        case .setCoverImage(let image):
            newState.workingPost?.coverImage = image
        }
        return newState
    }
    
    
}
