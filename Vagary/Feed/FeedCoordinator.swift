
//
//  FeedCoordinator.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit
import ReSwift


class FeedCoordinator: FeedHandler {
    var rootController: UINavigationController?
    var api = TravelApi()
    
    let dependencies: AppDependency
    let rootPresenter: NavigationPresenter
    
    init(dependencies: AppDependency){
        self.dependencies = dependencies
        rootPresenter = dependencies.factory.navigationPresenter()
        rootPresenter.push(presenter: dependencies.factory.feedPresenter(handler: self), animated: true)
    }
}

protocol FeedHandler { }



