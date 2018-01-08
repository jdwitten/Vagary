//
//  DraftPostCoordinator.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/4/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit
import ReSwift

class DraftPostCoordinator: DraftHandler {
    
    var rootController: UINavigationController?
    var route: [RoutingDestination] = [.postOptions]
    
    init(){
        
        if let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DraftPostRootNavController") as? UINavigationController{
            navController.tabBarItem = UITabBarItem(title: "Post", image: #imageLiteral(resourceName: "first"), tag: 0)
            rootController = navController
        }else{
            fatalError("Could Not Instantiate Draft View Controller")
        }
        
    }
}

protocol DraftHandler { }

enum DraftField{
    case Location(location: String)
    case Title(title: String)
    case Trip(trip: String)
}
