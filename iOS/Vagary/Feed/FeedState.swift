//
//  FeedState.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/7/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

struct FeedState: StateType {
    var query: String? = ""
    var posts: Loaded<[Post]> = .loaded(data: [])
    var selectedPost: String?
}

enum FeedAction: Action {
    case postSearch(String)
    case updatePosts(Loaded<[Post]>)
    case selectPost(String)
}

struct FeedReducer: SubstateReducer {
    
    typealias SubstateType = FeedState
    typealias ActionType = FeedAction
    func unwrap(action: Action, state: AppState) -> StateType? {
        if action is FeedAction {
            return state.authenticatedState?.feed
        } else {
            return nil
        }
    }
    
    func wrap(substate: FeedState, appState: AppState) -> AppState {
        let auth = appState.authenticatedState ?? AuthenticatedState()
        let authState = AuthenticatedState(auth: auth.auth, feed: substate, passport: auth.passport, draft: auth.draft)
        return AppState.authenticated(authState)
    }
    
    func reduce(action: FeedAction, substate: FeedState) -> FeedState {
        var nextState = substate
        switch action {
        case .postSearch(let query):
            nextState.query = query
        case .updatePosts(let posts):
            nextState.posts = posts
        case .selectPost(let post):
            nextState.selectedPost = post
        }
        return nextState
    }
}
