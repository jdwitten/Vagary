//
//  AppCoordinator.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit


class AppCoordinator: NSObject, StoreSubscriber, UITabBarControllerDelegate{
    
    var passportCoordinator: PassportCoordinator?
    var feedCoordinator: FeedCoordinator?
    var rootCoordinator: Coordinator?
    var draftPostCoordinator: DraftPostCoordinator?
    
    override init(){
        super.init()
        let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ControllerStoryboardId.RootTabBarController.rawValue) as! UITabBarController
        tabBarController.delegate = self
    
        feedCoordinator = FeedCoordinator()
        passportCoordinator = PassportCoordinator()
        draftPostCoordinator = DraftPostCoordinator()
        
        tabBarController.viewControllers = [feedCoordinator!.rootController!, passportCoordinator!.rootController!, draftPostCoordinator!.rootController!]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.rootViewController = tabBarController
        appDelegate.window?.makeKeyAndVisible()
    }
    
}

extension AppCoordinator{
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let viewController = viewController as? UINavigationController, viewController.childViewControllers[0] is FeedViewController{
            ViaStore.sharedStore.dispatch(ChangeTab(route: .feed))
        }
        else if let viewController = viewController as? UINavigationController, viewController.childViewControllers[0] is PassportViewController{
            ViaStore.sharedStore.dispatch(ChangeTab(route: .passport))
        }
        else if let viewController = viewController as? UINavigationController, viewController.childViewControllers[0] is PostOptionsViewController{
            ViaStore.sharedStore.dispatch(ChangeTab(route: .draftPost))
        }
    }
    
}


extension Coordinator {
    
    func build(newRoute: [RoutingDestination]) {
        guard rootController != nil else { return }
        var rootViewControllers = rootController!.viewControllers
        for newRouteIndex in 0..<newRoute.count {
            if newRouteIndex > route.count - 1 { //case: more controllers in new route so push onto nav stack
                pushViewController(newRoute[newRouteIndex])
                
            } else if newRoute[newRouteIndex] != route[newRouteIndex] { //case: differing routes so replace top of stack with new route
                let newTopOfStack = newRoute[newRouteIndex...].flatMap { $0.viewController }
                rootViewControllers.removeLast(route.count - newRouteIndex)
                rootController!.setViewControllers(rootViewControllers, animated: true)
                newTopOfStack.forEach {
                    rootController!.pushViewController($0, animated: true)
                }
                break
            }
        }
        if newRoute.count < route.count { //case: less controllers in new route so pop off existing routes
            rootViewControllers.removeLast(route.count - newRoute.count)
            rootController!.setViewControllers(rootViewControllers, animated: true)
        }
    }
    
    func pushViewController(_ destination: RoutingDestination){
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: destination.rawValue)
        rootController?.pushViewController(viewController, animated: true)
    }
}
