//
//  Action.swift
//  Vagary
//
//  Created by Jonathan Witten on 8/15/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

struct PostSearch: Action{
    var query: String
}

struct PostResponse: Action{
    var posts: Loaded<[Post]>
}
