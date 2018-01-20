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
        passportCoordinator = PassportCoordinator(dependencies: dependencies)
        draftPostCoordinator = DraftPostCoordinator(dependencies: dependencies)
        rootPresenter = dependencies.factory.rootPresenter()
        
        guard let feedRoot = feedCoordinator?.rootPresenter,
            let passportRoot = passportCoordinator?.rootPresenter,
            let draftRoot = draftPostCoordinator?.rootPresenter else {
                return
        }
        
        tabBarPresenter.presenters = [feedRoot,
                                      passportRoot,
                                      draftRoot]
        
        rootPresenter.setRoot(presenter: tabBarPresenter)
        
    }
}
