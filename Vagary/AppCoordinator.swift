//
//  AppCoordinator.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit
import ReSwift


protocol Coordinator{
    
    func subscribe()
    
    func unsubscribe()
    
}

class AppCoordinator: NSObject, FeedCoordinatorDelegate, PassportCoordinatorDelegate, DraftPostCoordinatorDelegate, StoreSubscriber, UITabBarControllerDelegate{
    
    var passportCoordinator: PassportCoordinator?
    var feedCoordinator: FeedCoordinator?
    var rootCoordinator: Coordinator?
    var draftPostCoordinator: DraftPostCoordinator?
    
    override init(){
        super.init()
        let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ControllerStoryboardId.RootTabBarController.rawValue) as! UITabBarController
        tabBarController.delegate = self
    
        feedCoordinator = FeedCoordinator()
        feedCoordinator?.delegate = self
        
        passportCoordinator = PassportCoordinator()
        passportCoordinator?.delegate = self
        
        draftPostCoordinator = DraftPostCoordinator()
        draftPostCoordinator?.delegate = self
        
        tabBarController.viewControllers = [feedCoordinator!.rootController!, passportCoordinator!.rootController!, draftPostCoordinator!.rootController!]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.rootViewController = tabBarController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    func newState(state: AppState){
        if state.routing.selectedTab != RoutingDestination.destination(ofCoordinator: rootCoordinator){
            rootCoordinator?.unsubscribe()
            if state.routing.selectedTab == .feed { rootCoordinator = feedCoordinator }
            else if state.routing.selectedTab == .passport { rootCoordinator = passportCoordinator }
            else if state.routing.selectedTab == .draftPost { rootCoordinator = draftPostCoordinator}
            rootCoordinator?.subscribe()
        }
    }
    
    
}

extension AppCoordinator{
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let viewController = viewController as? UINavigationController, viewController.childViewControllers[0] is FeedViewController{
            store.dispatch(ChangeTab(route: .feed))
        }
        else if let viewController = viewController as? UINavigationController, viewController.childViewControllers[0] is PassportViewController{
            store.dispatch(ChangeTab(route: .passport))
        }
        else if let viewController = viewController as? UINavigationController, viewController.childViewControllers[0] is DraftPostViewController{
            store.dispatch(ChangeTab(route: .draftPost))
        }
    }
    
}

enum RoutingDestination: String{
    case feed = "FeedViewController"
    case passport = "PassportViewController"
    case postDetail = "PostDetailViewController"
    case tripDetail = "TripDetailViewController"
    case draftPost = "DraftPostViewController"
    
    static func destination(ofViewController viewController: UIViewController?) -> RoutingDestination?{
        if viewController is FeedViewController{
            return .feed
        }
        else if viewController is PassportViewController{
            return .passport
        }
        else if viewController is PostDetailViewController{
            return .postDetail
        }
        else if viewController is TripDetailViewController{
            return .tripDetail
        }
        else if viewController is DraftPostViewController{
            return .draftPost
        }
        else{
            return nil
        }
    }
    
    static func destination(ofCoordinator coordinator: Coordinator?) -> RoutingDestination?{
        if coordinator is FeedCoordinator{
            return .feed
        }
        else if coordinator is PassportCoordinator{
            return .passport
        }
        else if coordinator is DraftPostCoordinator{
            return .draftPost
        }
        else{
            return nil
        }
    }
}
