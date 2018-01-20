//
//  AppState.swift
//  Vagary
//
//  Created by Jonathan Witten on 8/15/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

enum AppState: StateType {
    case unauthenticated
    case authenticated(AuthenticatedState)
    
    var authenticatedState: AuthenticatedState? {
        if case .authenticated(let auth) = self {
            return auth
        } else {
            return nil
        }
    }
    
}

struct AuthenticatedState {
    var auth: AuthState = AuthState()
    var feed: FeedState = FeedState()
    var passport = PassportState()
    var draft = DraftState()
}

enum AppAction: Action {
    
}

struct AuthState{
    var user: User? = User(id: 1, firstName: "first", lastName: "last")
}
