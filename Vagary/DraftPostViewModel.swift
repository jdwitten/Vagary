//
//  DraftPostViewModel.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/4/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift


struct DraftPostViewModel{
    
    var post: Post?
    
    init(_ state: AppState){
        
        post = state.draft.post
        
    }
}
