//
//  TravelAPIResponses.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation

struct PostsResponse {
    var posts: [Post]
}

struct TripsResponse {
    var trips: [Trip]
}

struct CreateDraftResponse {
    var draft: Post
}

enum TravelAPIResponse{
    
    case PostsResponse([Post])
    case Error
    case Loading
    
}
