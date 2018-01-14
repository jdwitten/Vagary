//
//  DraftPostCoordinator.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/4/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

class DraftPostCoordinator: DraftHandler {
    
    var rootController: NavigationPresenter?
    
    var dependencies: AppDependency
    var factory: PresenterFactory {
        return dependencies.factory
    }
    
    init(dependencies: AppDependency){
        self.dependencies = dependencies
        rootController = factory.navigationPresenter()
        rootController?.push(presenter: factory.postOptionsPresenter(handler: self), animated: true)
        
    }
}

protocol DraftHandler { }

enum DraftField{
    case Location(location: String)
    case Title(title: String)
    case Trip(trip: String)
}

enum PostOption {
    case images
    case post
    case drafts
}
