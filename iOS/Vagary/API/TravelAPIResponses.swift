//
//  TravelAPIResponses.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation

struct PostsResponse: Codable {
    var posts: [Post]
}

struct TripsResponse: Codable {
    var trips: [Trip]
}

struct DraftResponse: Codable {
    var draft: Draft
}

struct PostResponse: Codable {
    var post: Post
}

struct CreatePostRequest: Codable {
    var user: Int
    var body: String
    var title: String
    var location: String
}

struct CreatePostResponse: Codable {
    var success: Bool
}

struct PostImageURLResponse: Codable {
    var signedRequest: String
    var url: String
}

struct UploadImageResponse: Codable {
    
}
