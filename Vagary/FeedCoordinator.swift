//
//  FeedCoordinator.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit


struct FeedCoordinator: Coordinator{
    
    var feedController: FeedViewController?
    var delegate: FeedCoordinatorDelegate?
    
    mutating func start(){
        
        guard delegate != nil else{
            fatalError("Initialization Error in Feed Coordinator")
        }
        
        if let rootController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ControllerStoryboardId.FeedViewController.rawValue) as? FeedViewController{
            rootController.tabBarItem = UITabBarItem(title: "Feed", image: #imageLiteral(resourceName: "first"), tag: 0)
            feedController = rootController
        }else{
            fatalError("Could Not Instantiate Feed View Controller")
        }
        
    }
    
    
}


protocol FeedCoordinatorDelegate{

}
