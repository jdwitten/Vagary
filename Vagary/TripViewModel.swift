//
//  TripViewModel.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/3/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//
import Foundation
import ReSwift


struct TripViewModel{
    
    var title: String?
    var postsTitle: String?
    
    init(_ state: AppState){
        
        let trip = state.tripDetail.trip
        let posts = state.tripDetail.posts
        
        switch trip{
        case .loaded(let trip):
            title = trip.title
        case .loading:
            title = ""
        case .error:
            title = ""
        }
        
        switch posts{
        case .loaded(let posts):
            postsTitle = posts[0].title
        case .loading:
            postsTitle = ""
        case .error:
            postsTitle = ""
        }
    }
}
