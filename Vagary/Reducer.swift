//
//  Reducer.swift
//  Vagary
//
//  Created by Jonathan Witten on 8/15/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

func AppReducer(action: Action, state: AppState?) -> AppState {
    
    
    let state = state ?? AppState(feed: FeedState(query: "", posts: .loaded(data: [])))
    
    return AppState(
        feed: FeedReducer(action: action, state: state.feed)
    )
}

func FeedReducer(action: Action, state: FeedState?) -> FeedState {
    var state = state ?? FeedState(query: "", posts: .loaded(data: []))
    
    if let action = action as? PostSearch {
        state.query = action.query
    }
    else if let action = action as? PostResponse{
        state.posts = action.posts
        print(state.posts)
    }
    return state
}
