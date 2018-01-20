//
//  User.swift
//  Vagary
//
//  Created by Jonathan Witten on 8/20/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation

struct User: Codable, Resource{
    var id: Int
    var firstName: String
    var lastName: String
}
