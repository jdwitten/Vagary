//
//  PassportCoordinator.swift
//  Vagary
//
//  Created by Jonathan Witten on 8/20/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit
import ReSwift

class PassportCoordinator: PassportHandler {
    
    var rootController: UINavigationController?
    var route: [RoutingDestination] = [.passport]
    let api = TravelApi()
    
    init(){
        
        if let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PassportRootNavController") as? UINavigationController{
            navController.tabBarItem = UITabBarItem(title: "Passport", image: #imageLiteral(resourceName: "first"), tag: 0)
            rootController = navController
        }else{
            fatalError("Could Not Instantiate Passport View Controller")
        }
        
    }
}

protocol PassportHandler { }

