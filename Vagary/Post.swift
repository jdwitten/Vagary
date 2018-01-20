//
//  Post.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation


struct Post: Codable, Resource {
    
    var id: Int
    var author: Int
    var content: [PostElement]
    var title: String
    var trip: Trip
    var location: String
}



