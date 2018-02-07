//
//  Trip.swift
//  Vagary
//
//  Created by Jonathan Witten on 8/20/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation


struct Trip: Codable, Resource {
    var id: Int
    var title: String
    var posts: [Int]
}
