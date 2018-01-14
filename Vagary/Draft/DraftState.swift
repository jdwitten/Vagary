//
//  DraftState.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/9/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

struct DraftState{
    var workingPost: Post? = Post(id: 1, author: 1, content: [], title: "", trip: Trip(id : 1, title: "", posts : []), location: "" )
    var content: [PostElement] = []
    var error: String? = nil
    var currentlyEditing: DraftField? = nil
    var drafts: Loaded<[Post]> = .loading
}

enum DraftAction: Action {
    case selectPostOption(PostOption)
    case changeDraftText(String)
    case createDraft(Post)
    case editDraftDetail(DraftField)
    case updateDraft(DraftField)
    case showDraft([PostElement])
    case loadedDrafts(Loaded<[Post]>)
    case addPostElement(PostElement)
}

struct DraftReducer: SubstateReducer {
    
    typealias ActionType = DraftAction
    
    typealias SubstateType = DraftState
    
    func unwrap(action: Action, state: AppState) -> AppState? {
        if action is DraftAction {
            return state
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
        case .selectPostOption(let field):
            break
        case .changeDraftText(let text):
            newState.content = [PostElement.text(text)]
        case .createDraft(let post):
            break
        case .editDraftDetail(let field):
            switch field {
            case .Location(let location):
                newState.workingPost?.location = location
            case .Trip(let trip):
                newState.workingPost?.trip = Trip(id: 0, title: trip, posts: [])
            case .Title(let title):
                newState.workingPost?.title = title
            }
        case .updateDraft(let field):
            break
        case .showDraft(let draft):
            break
        case .loadedDrafts(let drafts):
            newState.drafts = drafts
        case .addPostElement(let element):
            newState.content.append(element)
        }
        return newState
    }
    
    
}
