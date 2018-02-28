//
//  PostViewModel.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/2/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift


struct PostViewModel: ViewModel {
    
    var post: String?
    var loading: Bool
    
    static func build(_ state: AppState) -> PostViewModel? {
        
        if let post = state.authenticatedState?.feed.selectedPost {
            return PostViewModel(post: post, loading: false)
        } else {
            return PostViewModel(post: nil, loading: true)
        }
    }
}
