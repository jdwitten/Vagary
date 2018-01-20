//
//  Factory.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/7/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit
import ReSwift

protocol PresenterFactory {
    func feedPresenter(handler: FeedHandler) -> FeedPresenter
    func tabBarPresenter() -> TabBarPresenter
    func navigationPresenter() -> NavigationPresenter
    func rootPresenter() -> RootPresenter
    func passportPresenter(handler: PassportHandler) -> PassportPresenter
    func postOptionsPresenter(handler: DraftHandler) -> PostOptionsPresenter
    func createPostPresenter(handler: DraftHandler) -> CreatePostPresenter
    func createDraftDetailPresenter(handler: DraftHandler, field: DraftField) -> CreateDraftDetailPresenter
}

struct UIPresenterFactory: PresenterFactory {
    
    func rootPresenter() -> RootPresenter {
        return UIRootPresenter()
    }
    func feedPresenter(handler: FeedHandler) -> FeedPresenter {
        return FeedViewController.build(handler: handler)
    }
    
    func tabBarPresenter() -> TabBarPresenter {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ControllerStoryboardId.RootTabBarController.rawValue) as! UITabBarController
    }
    
    func navigationPresenter() -> NavigationPresenter {
        return UINavigationController()
    }
    
    func passportPresenter(handler: PassportHandler) -> PassportPresenter {
        return PassportViewController.build(handler: handler)
    }
    
    func postOptionsPresenter(handler: DraftHandler) -> PostOptionsPresenter {
        return PostOptionsViewController.build(handler: handler)
    }
    
    func createPostPresenter(handler: DraftHandler) -> CreatePostPresenter {
        return CreatePostViewController.build(handler: handler)
    }
    
    func createDraftDetailPresenter(handler: DraftHandler, field: DraftField) -> CreateDraftDetailPresenter {
        return CreateDraftDetailViewController.build(handler: handler, field: field)
    }
    
}
