//
//  PassportViewModel.swift
//  Vagary
//
//  Created by Jonathan Witten on 8/20/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

struct PassportViewModel{
    
    var name: String
    var userImageUrl: URL?
    var followersCount: Int
    var countriesCount: Int
    var postsCount: Int
    var following: Bool
    var country: String
    var handle: String
    var trips: [Trip]
    
    
    init(_ state: AppState){
        let passport = state.passport
        
        name = "firstName lastName"
        userImageUrl = nil
        followersCount = 0
        countriesCount = 0
        postsCount = 0
        following = false
        country = "U.S."
        handle = "@jwitt"
        
        switch passport.trips{
        case .error:
            trips = []
        case .loaded(let data):
            trips = data
        case .loading:
            trips = []
        }
    }
    
}


