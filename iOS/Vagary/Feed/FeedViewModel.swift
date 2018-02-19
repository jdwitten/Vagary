//
//  FeedViewModel.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation


struct FeedViewModel: ViewModel, TableViewModel {    
    static var cellsToRegister: [String] = ["PostFeedTableViewCell"]

    var sections: [SectionViewModel]
    
    var query: String = ""
    var loading: Bool = false
    
    
    static func build(_ state: AppState) -> FeedViewModel? {
        guard let feedState = state.authenticatedState?.feed else {
            return nil
        }
        
        switch feedState.posts{
        case .loaded(let posts):
            let postCells = posts.map({ PostCellViewModel(post: $0) })
            let sections = [StandardTableViewSection(cells: postCells)]
            return FeedViewModel(sections: sections, query: feedState.query ?? "", loading: false)
        case .loading:
            return FeedViewModel(sections: [], query: feedState.query ?? "", loading: true)
        case .error:
            return FeedViewModel(sections: [], query: feedState.query ?? "", loading: false)
        }
    }
}

enum FeedCellAction: AnyCellAction {
    case selectPost
}


struct PostSearchQuery{
    
    let queryText: String
    let queryUser: Int
    let requestingUser: Int
}
