//
//  Reducer.swift
//  Vagary
//
//  Created by Jonathan Witten on 8/15/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

func AppReducer(action: Action, state: AppState?) -> AppState {
    
    
    let state = state ?? AppState()
    
    print(action)
    
    return AppState(
        routing: routingReducer(action: action, state: state),
        auth: authReducer(action: action, state: state),
        feed: feedReducer(action: action, state: state),
        passport: passportReducer(action: action, state: state),
        postDetail: postDetailReducer(action: action, state: state),
        tripDetail: tripDetailReducer(action: action, state: state),
        draft: draftReducer(action: action, state: state)
    )
}

func feedReducer(action: Action, state: AppState?) -> FeedState {
    var feedState = state?.feed ?? FeedState()
    if let action = action as? PostSearch {
        feedState.query = action.query
    }
    else if let action = action as? PostResponse{
        feedState.posts = action.posts
    }
     return feedState
}


func routingReducer(action: Action, state: AppState?) -> RoutingState{
    var routingState = state?.routing ?? RoutingState()
    if action is ShowPostDetail{
        if var route = routingState.routes[routingState.selectedTab]{
            route.append(.postDetail)
            routingState.routes[routingState.selectedTab] = route
        }
    }
    else if action is ShowTripDetail{
        if var route = routingState.routes[routingState.selectedTab]{
            route.append(.tripDetail)
            routingState.routes[routingState.selectedTab] = route
            print(route)
        }
    }
    else if let action = action as? SelectPostOption{
        if var route = routingState.routes[routingState.selectedTab]{
            route.append(action.option)
            routingState.routes[routingState.selectedTab] = route
            print(route)
        }
    }
    else if let action = action as? CreateDraft{
        if case .loading = action.post{
            return routingState
        }
        else if case .loaded = action.post{
            if var route = routingState.routes[routingState.selectedTab]{
                route.append(.draftPost)
                routingState.routes[routingState.selectedTab] = route
            }
        }
    }
    else if action is EditDraftDetail{
        if var route = routingState.routes[routingState.selectedTab]{
            route.append(.editDraftDetail)
            routingState.routes[routingState.selectedTab] = route
        }
    }
    else if action is UpdateDraft{
        if var route = routingState.routes[routingState.selectedTab]{
            route.removeLast()
            routingState.routes[routingState.selectedTab] = route
        }
    }
    else if action is ShowDraft{
        if var route = routingState.routes[routingState.selectedTab]{
            route.append(.draftPost)
            routingState.routes[routingState.selectedTab] = route
        }
    }
    else if action is PopNavigation{
        if var route = routingState.routes[routingState.selectedTab]{
            route.removeLast()
            routingState.routes[routingState.selectedTab] = route
        }
    }
    else if let action = action as? ChangeTab{
        routingState.selectedTab = action.route
    }
    return routingState
    
}


func passportReducer(action: Action, state: AppState?) -> PassportState{
    
    var passportState = state?.passport ?? PassportState()
    
    if let action = action as? TripsSearch{
        
    }
    else if let action = action as? TripsResponse{
        passportState.trips = action.trips
    }
    
    return passportState
}

func authReducer(action: Action, state: AppState?) -> AuthState{
    
    let authState = state?.auth ?? AuthState()
    
    return authState
}


func postDetailReducer(action: Action, state: AppState?) -> PostDetailState{
    var postDetailState = state?.postDetail ?? PostDetailState()
    
    if let action = action as? PostDetailResponse{
        postDetailState.post = action.post
    }
    
    return postDetailState
}

func tripDetailReducer(action: Action, state: AppState?) -> TripDetailState{
    var tripDetailState = state?.tripDetail ?? TripDetailState()
    
    if let action = action as? TripDetailResponse{
        tripDetailState.trip = action.trip
        
    }
    else if let action = action as? TripDetailPostsResponse{
        tripDetailState.posts = action.posts
    }
    
    return tripDetailState
}

func draftReducer(action: Action, state: AppState?) -> DraftState{
    var state = state ?? AppState()
    var draftState = state.draft
    
    if let action = action as? ChangeDraftText{
        //draftState.text = action.newText
    }
        
    else if let action = action as? UpdateDraft{
        switch action.field{
        case .Location(let location):
            guard location != "" else {
                draftState.error = "Please check location for errors"
                break
            }
            draftState.workingPost?.location = location
        case .Trip(let trip):
            guard trip != "" else {
                draftState.error = "Please check trip for errors"
                break
            }
            draftState.workingPost?.trip.title = trip
        case .Title(let title):
            guard title != "" else {
                draftState.error = "Please check title for errors"
                break
            }
            draftState.workingPost?.title = title
        }
    }
    else if let action = action as? EditDraftDetail{
        draftState.currentlyEditing = action.field
    }
    
    else if let action = action as? AddPostElement{
        draftState.content.append(action.element)
    }
    else if let action = action as? LoadedDrafts{
        draftState.drafts = action.drafts
    }
    
    
    
    return draftState
}


