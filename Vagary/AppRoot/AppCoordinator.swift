//
//  AppCoordinator.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation


class AppCoordinator {
    
    var passportCoordinator: PassportCoordinator?
    var feedCoordinator: FeedCoordinator?
    var draftPostCoordinator: DraftPostCoordinator?
    
    var rootPresenter: RootPresenter
    
    var dependencies: AppDependency
    
    
    init(dependencies: AppDependency){
        self.dependencies = dependencies
        var tabBarPresenter = dependencies.factory.tabBarPresenter()
        
        feedCoordinator = FeedCoordinator(dependencies: dependencies)
        rootPresenter = dependencies.factory.rootPresenter()
        
        tabBarPresenter.presenters = [dependencies.factory.feedPresenter(handler: feedCoordinator!)]
        rootPresenter.setRoot(presenter: tabBarPresenter)
        
    }
}
