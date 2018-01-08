
//
//  FeedCoordinator.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit
import ReSwift


class FeedCoordinator: Coordinator, StoreSubscriber, FeedHandler{
    var rootController: UINavigationController?
    var route: [RoutingDestination] = [.feed]
    var api = TravelApi()
    
   init(){
        
        if let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedRootNavController") as? UINavigationController{
            navController.tabBarItem = UITabBarItem(title: "Feed", image: #imageLiteral(resourceName: "first"), tag: 0)
            rootController = navController
        }else{
            fatalError("Could Not Instantiate Feed View Controller")
        }
        ViaStore.sharedStore.subscribe(self)
    }
    
    func newState(state: AppState){
        guard state.routing.selectedTab == .feed else { return }
        build(newRoute: state.routing.routes[.feed]!)
        route = state.routing.routes[.feed]!
    }
}

protocol FeedHandler { }



