//
//  TravelApi.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation

class TravelApi{
    
    
    static func getPosts(withQuery query: String, completion: @escaping (Loaded<[Post]>) -> ()){
        
        let post1 = Post(json: ["id": 1, "author": 2, "text": "This is a Post", "title": String(describing: arc4random())])!
        let post2 = Post(json: ["id": 2, "author": 5, "text": "This is another Post", "title": String(describing: arc4random())])!
        let post3 = Post(json: ["id": 2, "author": 5, "text": "One More Post", "title": String(describing: arc4random())])!
        
        completion(.loaded(data: [post1, post2, post3]))
    }
}
