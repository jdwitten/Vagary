//
//  AppState.swift
//  Vagary
//
//  Created by Jonathan Witten on 8/15/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType{
    var feed: FeedState
}

struct FeedState: StateType{
    var query: String?
    var posts: Loaded<[Post]>
}
