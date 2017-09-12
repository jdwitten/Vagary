//
//  PostViewModel.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/2/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift


struct PostViewModel{
    
    var post: Post?
    var loading: Bool
    
    init(_ state: AppState){
        
        let post = state.postDetail.post
        
        switch post{
        case .loaded(let post):
            self.post = post
            loading = false
        case .loading:
            self.post = nil
            loading = true
        case .error:
            self.post = nil
            loading = false
        }
    }
}
