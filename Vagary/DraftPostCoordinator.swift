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

class DraftPostCoordinator: Coordinator, StoreSubscriber, DraftPostControllerDelegate{
    
    var rootController: UINavigationController?
    var delegate: DraftPostCoordinatorDelegate?
    let api = TravelApi()
    
    init(){
        
        if let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DraftPostRootNavController") as? UINavigationController{
            navController.tabBarItem = UITabBarItem(title: "Post", image: #imageLiteral(resourceName: "first"), tag: 0)
            rootController = navController
            if let draftPostController = rootController?.topViewController as? DraftPostViewController{
                draftPostController.delegate = self as DraftPostControllerDelegate
            }
        }else{
            fatalError("Could Not Instantiate Passport View Controller")
        }
        
    }
    
    func newState(state: AppState){
        if state.routing.routes[.draftPost]?.last != RoutingDestination.destination(ofViewController: rootController?.topViewController){
            pushViewController(state.routing.routes[.draftPost]?.last ?? .draftPost)
        }
    }
    
    func pushViewController(_ destination: RoutingDestination){
        print("push view controller")
        print(destination)
        if var viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: destination.rawValue) as? DraftPostController{
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


protocol DraftPostCoordinatorDelegate{
    
}

protocol DraftPostController{
    
    var delegate: DraftPostControllerDelegate? {get set}
    
}

protocol DraftPostControllerDelegate{
    
    func selectedTrip(_ trip: Trip)
    
    func popNavigation()
    
}
