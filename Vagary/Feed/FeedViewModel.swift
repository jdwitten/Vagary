//
//  FeedViewModel.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation


struct FeedViewModel: ViewModel {
    
    
    var posts: [Post] = []
    var query: String = ""
    var loading: Bool = false
    
    
    static func build(_ state: AppState) -> FeedViewModel? {
        guard let feedState = state.authenticatedState?.feed else {
            return nil
        }
        
        switch feedState.posts{
        case .loaded(let data):
            return FeedViewModel(posts: data, query: feedState.query ?? "", loading: false)
        case .loading:
            return FeedViewModel(posts: [], query: feedState.query ?? "", loading: true)
        case .error:
            return FeedViewModel(posts: [], query: feedState.query ?? "", loading: false)
        }
    }
    
    
}


struct PostSearchQuery{
    
    let queryText: String
    let queryUser: Int
    let requestingUser: Int
}
