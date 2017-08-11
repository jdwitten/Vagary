//
//  AppCoordinator.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit


protocol Coordinator{
    
    mutating func start()
}

struct AppCoordinator: Coordinator, FeedCoordinatorDelegate{
    
    var childCoordinators: [Coordinator]
    
    
    mutating func start(){
        
        let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ControllerStoryboardId.RootTabBarController.rawValue) as! UITabBarController
    
        var feedCoordinator = FeedCoordinator()
        feedCoordinator.delegate = self
        feedCoordinator.start()
        
        tabBarController.viewControllers = [feedCoordinator.feedController!]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.rootViewController = tabBarController
        appDelegate.window?.makeKeyAndVisible()
        
        
    }
    
    
}
