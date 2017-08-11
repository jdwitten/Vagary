//
//  Post.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation


struct Post: JSONParseable{
    
    var id: Int
    var author: Int
    var text: String
    var title: String
    
    
    init?(json: [String: Any]){
        
        guard let id = json["id"] as? Int,
            let author = json["author"] as? Int,
            let text = json["text"] as? String,
            let title = json["title"] as? String else{
                return nil
        }
        
        self.id = id
        self.author = author
        self.text = text
        self.title = title
    }
    
    func toJSON() -> [String: Any]{
        
        return ["id": id, "author": author, "text": text, "title": title]
        
    }
    
    
    
}
