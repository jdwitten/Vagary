//
//  PassportState.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/9/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

struct PassportState: StateType {
    var user: User? = nil
    var trips: Loaded<[Trip]> = .loaded(data: [])
    var selectedTrip: Trip?
    var selectedTripPosts: Loaded<[Post]> = .loaded(data: [])
    var newTripImage: DraftImage?
    var newTripTitle: String?
}

enum PassportAction: Action {
    case tripsSearch(User)
    case tripsResponse(Loaded<[Trip]>)
    case tripDetailResponse(Loaded<Trip>)
    case tripDetailPostsResponse(Loaded<[Post]>)
    case showTripDetail(Int)
    case setNewTripImage(DraftImage)
    case setNewTripTitle(String)
    case endNewTrip
}

struct PassportReducer: SubstateReducer {
    
    typealias ActionType = PassportAction
    typealias SubstateType = PassportState
    
    func unwrap(action: Action, state: AppState) -> StateType? {
        if action is PassportAction {
            return state.authenticatedState?.passport
        } else {
            return nil
        }
    }
    
    func wrap(substate: PassportState, appState: AppState) -> AppState {
        guard let auth = appState.authenticatedState else {
            return AppState.unauthenticated
        }
        
        return AppState.authenticated(AuthenticatedState(auth: auth.auth, feed: auth.feed, passport: substate, draft: auth.draft))
    }
    
    func reduce(action: PassportAction, substate: PassportState) -> PassportState {
        var newState = substate
        switch action {
        case .showTripDetail(let id):
            break
        case .tripsResponse(let trips):
            newState.trips = trips
        case .tripDetailPostsResponse(let posts):
            break
        case .tripsSearch(let user):
            newState.user = user
        case .tripDetailResponse(let trip):
            break
        case .endNewTrip:
            newState.newTripImage = nil
            newState.newTripTitle = nil
        case .setNewTripImage(let image):
            newState.newTripImage = image
        case .setNewTripTitle(let title):
            newState.newTripTitle = title
        }
        return newState
    }
}
