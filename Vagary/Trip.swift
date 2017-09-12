//
//  Trip.swift
//  Vagary
//
//  Created by Jonathan Witten on 8/20/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation


struct Trip: JSONParseable{
    var id: Int
    var title: String
    var posts: [Int]
    
    init?(json: [String: Any]){
        
        guard let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let postsArray = json["posts"] as? [Int] else{
                return nil
        }
        
        self.id = id
        self.title = title
        self.posts = postsArray
        
    }
    
    func toJSON() -> [String : Any] {
        
        var postsJson: [[String: Any]] = []
        
        return ["id": self.id, "title": self.title, "posts": postsJson]
        
    }
    
}
