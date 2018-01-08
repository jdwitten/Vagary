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

struct TripsSearch: Action{
    var user: User
}

struct TripsResponse: Action {
    var trips: Loaded<[Trip]>
}

struct PostDetailResponse: Action{
    var post: Loaded<Post>
}

struct ShowPostDetail: Action{
    var postId: Int
}

struct TripDetailResponse: Action{
    var trip: Loaded<Trip>
}
struct TripDetailPostsResponse: Action{
    var posts: Loaded<[Post]>
}
struct ShowTripDetail: Action{
    var tripId: Int
}

struct ChangeTab: Action{
    var route: RoutingDestination
}

struct PopNavigation: Action{
    
}

struct SelectPostOption: Action{
    var option: RoutingDestination
}

struct ChangeDraftText: Action{
    var newText: String
}

struct CreateDraft: Action{
    var post: Loaded<Post>
}

struct EditDraftDetail: Action{
    var field: DraftField
}

struct UpdateDraft: Action{
    var field: DraftField
}

struct ShowDraft: Action{
    var content: [PostElement]
}

struct LoadedDrafts: Action{
    var drafts: Loaded<[Post]>
}

struct AddPostElement: Action{
    var element: PostElement
}
