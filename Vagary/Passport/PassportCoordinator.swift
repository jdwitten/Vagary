//
//  PassportCoordinator.swift
//  Vagary
//
//  Created by Jonathan Witten on 8/20/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

class PassportCoordinator: PassportHandler {
    
    var rootController: NavigationPresenter?
    let api = TravelApi()
    let dependencies: AppDependency
    var factory: PresenterFactory {
        return dependencies.factory
    }
    
    init(dependencies: AppDependency){
        self.dependencies = dependencies
        rootController = factory.navigationPresenter()
        rootController?.push(presenter: factory.passportPresenter(handler: self), animated: true)
    }
}

protocol PassportHandler { }

