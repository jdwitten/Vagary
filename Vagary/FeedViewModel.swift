//
//  FeedViewModel.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation


struct FeedViewModel{
    
    
    var posts: [Post] = []
    var query: String = ""
    
    
    init(_ state: AppState){
        let feedState = state.feed
        
        switch feedState.posts{
        case .loaded(let data):
            self.posts = data
        default:
            self.posts = []
        }
        
        query = feedState.query ?? ""
    }
    
    
}


struct PostSearchQuery{
    
    let queryText: String
    let queryUser: Int
    let requestingUser: Int
}
