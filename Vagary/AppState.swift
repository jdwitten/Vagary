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
    var routing: RoutingState = RoutingState()
    var auth: AuthState = AuthState()
    var feed: FeedState = FeedState()
    var passport = PassportState()
    var postDetail = PostDetailState()
    var tripDetail = TripDetailState()
    var draft = DraftState()
}

struct AuthState{
    var user: User? = User(id: 1, firstName: "first", lastName: "last")
}

struct FeedState: StateType{
    var query: String? = ""
    var posts: Loaded<[Post]> = .loaded(data: [])
}

struct PassportState{
    var user: User? = nil
    var trips: Loaded<[Trip]> = .loaded(data: [])
    var detail: [StateType] = []
}

struct RoutingState: StateType{
    var routes: [RoutingDestination: [RoutingDestination]] = [.feed: [.feed], .passport: [.passport], .draftPost: [.draftPost]]
    var selectedTab: RoutingDestination = .feed
}

struct PostDetailState{
    var post: Loaded<Post> = .loading
}

struct TripDetailState{
    var trip: Loaded<Trip> = .loading
    var posts: Loaded<[Post]> = .loading
}

struct DraftState{
    var post: Post?
}
