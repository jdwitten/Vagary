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

class PassportCoordinator: Coordinator, StoreSubscriber, PassportControllerDelegate{
    
    var rootController: UINavigationController?
    var delegate: PassportCoordinatorDelegate?
    let api = TravelApi()
    
    init(){
        
        if let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PassportRootNavController") as? UINavigationController{
            navController.tabBarItem = UITabBarItem(title: "Passport", image: #imageLiteral(resourceName: "first"), tag: 0)
            rootController = navController
            if let passportController = rootController?.topViewController as? PassportViewController{
                passportController.delegate = self as PassportControllerDelegate
            }
        }else{
            fatalError("Could Not Instantiate Passport View Controller")
        }
        
    }
    
    func newState(state: AppState){
        if state.routing.routes[.passport]?.last != RoutingDestination.destination(ofViewController: rootController?.topViewController){
            pushViewController(state.routing.routes[.passport]?.last ?? .passport)
        }
    }
    
    func pushViewController(_ destination: RoutingDestination){
        print("push view controller")
        print(destination)
        if var viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: destination.rawValue) as? PassportController{
            viewController.delegate = self
            rootController?.pushViewController(viewController as! UIViewController, animated: true)
        }
    }
    
    func selectedTrip(_ trip: Trip){
        print("show post")
        store.dispatch(ShowTripDetail(tripId: trip.id))
        api.getTrip(forId: trip.id){trip in
            store.dispatch(TripDetailResponse(trip: trip))
            
        }
        
        api.getPosts(forIds: trip.posts){ posts in
            store.dispatch(TripDetailPostsResponse(posts: posts))
        }
    }
    
    func popNavigation(){
        store.dispatch(PopNavigation())
    }
    
    func subscribe(){
        store.subscribe(self)
    }
    
    func unsubscribe(){
        store.unsubscribe(self)
    }
    
    
}


protocol PassportCoordinatorDelegate{
    
}

protocol PassportController{
    
    var delegate: PassportControllerDelegate? {get set}
    
}

protocol PassportControllerDelegate{
    
    func selectedTrip(_ trip: Trip)
    
    func popNavigation()
    
}
