//
//  AppCoordinator.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift


class AppCoordinator {
    
    var passportCoordinator: PassportCoordinator?
    var feedCoordinator: FeedCoordinator?
    var draftPostCoordinator: DraftPostCoordinator?
    var loginCoordinator: LoginCoordinator?
    
    var rootPresenter: RootPresenter?
    
    var dependencies: AppDependency
    
    var currentState: AppState
    
    init(dependencies: AppDependency){
        self.dependencies = dependencies
        self.currentState = .unauthenticated
    }
    
    func start() {
        rootPresenter = dependencies.factory.rootPresenter()
        ViaStore.sharedStore.subscribe(self)
    }
    
    func setAuthenticated() {
        var tabBarPresenter = dependencies.factory.tabBarPresenter()
        
        feedCoordinator = FeedCoordinator(dependencies: dependencies)
        passportCoordinator = PassportCoordinator(dependencies: dependencies)
        draftPostCoordinator = DraftPostCoordinator(dependencies: dependencies)
        
        guard let feedRoot = feedCoordinator?.rootPresenter,
            let passportRoot = passportCoordinator?.rootPresenter,
            let draftRoot = draftPostCoordinator?.rootPresenter else {
                return
        }
        
        tabBarPresenter.presenters = [feedRoot,
                                      passportRoot,
                                      draftRoot]
        
        rootPresenter?.setRoot(presenter: tabBarPresenter)
    }
    
    func setUnauthenticated() {
        loginCoordinator = LoginCoordinator(dependencies: dependencies)
        guard let coord = loginCoordinator else { return }
        let login = dependencies.factory.loginPresenter(handler: coord)
        rootPresenter?.setRoot(presenter: login)
    }
}

extension AppCoordinator: StoreSubscriber {
    func newState(state: AppState) {
        switch state {
        case .unauthenticated:
            setUnauthenticated()
        case .authenticated(_):
            if case AppState.unauthenticated = currentState {
                setAuthenticated()
            }
        }
        currentState = state
    }
}
