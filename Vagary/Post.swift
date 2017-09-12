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
    var content: [PostElement]
    var title: String
    
    
    
    init?(json: [String: Any]){
        
        guard let id = json["id"] as? Int,
            let author = json["author"] as? Int,
        let body = json["body"] as? [[String: Any]],
            let title = json["title"] as? String else{
                return nil
        }
        
        content = []
        
        
        for element in body{
            guard let elementType = element["type"] as? String,
                let elementString = element["content"] as? String else{
                    continue
            }
            
            if elementType == "text"{
                content.append(elementString)
            }
            else if elementType == "image",
                let url = URL(string: elementString){
                content.append(url)
            }
        }
        self.id = id
        self.author = author
        self.title = title
    }
    
    func toJSON() -> [String: Any]{
        
        return ["id": id, "author": author, "text": "text", "title": title]
        
    }
    
    
    
}

protocol PostElement{
    
}

extension String: PostElement{
    
}

extension URL: PostElement{
    
}
