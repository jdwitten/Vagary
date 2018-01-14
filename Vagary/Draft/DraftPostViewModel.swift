//
//  DraftPostViewModel.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/4/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift


struct DraftPostViewModel: ViewModel {
    
    var content: [PostElement] = []
    
    static func build(_ state: AppState) -> DraftPostViewModel? {
        guard let auth = state.authenticatedState else {
            return nil
        }
        return DraftPostViewModel(content: auth.draft.content)
    }
}
