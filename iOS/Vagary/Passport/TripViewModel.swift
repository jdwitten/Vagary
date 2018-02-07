//
//  TripViewModel.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/3/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//
import Foundation
import ReSwift


struct TripViewModel: ViewModel{
    
    var title: String?
    var postsTitle: String?
    
    static func build(_ state: AppState) -> TripViewModel? {
        
        if let tripState = state.authenticatedState?.passport {
            let trip = tripState.selectedTrip
            let posts = tripState.selectedTripPosts
            
            let title = trip?.title
            var postsTitle: String
            
            switch posts{
            case .loaded(let posts):
                postsTitle = posts[0].title
            case .loading:
                postsTitle = ""
            case .error:
                postsTitle = ""
            }
            
            return TripViewModel(title: title, postsTitle: postsTitle)
        } else {
            return nil
        }
    }
}
