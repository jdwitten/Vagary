//
//  PassportCoordinator.swift
//  Vagary
//
//  Created by Jonathan Witten on 8/20/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift
import PromiseKit

class PassportCoordinator: PassportHandler {
    
    var rootPresenter: NavigationPresenter?
    let api = TravelApi()
    let dependencies: AppDependency
    var factory: PresenterFactory {
        return dependencies.factory
    }
    
    init(dependencies: AppDependency){
        self.dependencies = dependencies
        rootPresenter = factory.navigationPresenter()
        rootPresenter?.push(presenter: factory.passportPresenter(handler: self), animated: true)
    }
    
    func updateTrips() {
        let _ = firstly {
            dependencies.api.getTrips()
        }.then { response -> Void in
            ViaStore.sharedStore.dispatch(PassportAction.tripsResponse(.loaded(data: response.trips)))
        }.catch{ error in
            ViaStore.sharedStore.dispatch(PassportAction.tripsResponse(.error))
        }
    }
}

protocol PassportHandler {
    func updateTrips()
}

