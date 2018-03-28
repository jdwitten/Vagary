//
//  Protocols.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation


protocol JSONParseable{
    
    init?(json: [String: Any])
    
    func toJSON() -> [String: Any]

}

enum Loaded<T>{
    case loading
    case loaded(data: T)
    case error
}

protocol StoreListener{
    func newState(_ : AppState)
}

protocol Resource{
}

enum ResourcePath: String{
    case post = "post"
    case posts = "posts"
    case trip = "trip"
    case trips = "trips"
    case user = "user"
    case draft = "draft"
    case drafts = "drafts"
    case postImageRequest = "posts/image/request"
    case login = "auth/login"
    case token = "auth/token"
}
