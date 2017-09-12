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


class FeedCoordinator: Coordinator, StoreSubscriber, FeedControllerDelegate{
    
    var delegate: FeedCoordinatorDelegate?
    var rootController: UINavigationController?
    var api = TravelApi()
    
   init(){
        
        if let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedRootNavController") as? UINavigationController{
            navController.tabBarItem = UITabBarItem(title: "Feed", image: #imageLiteral(resourceName: "first"), tag: 0)
            rootController = navController
            if let feedController = rootController?.topViewController as? FeedViewController{
                feedController.delegate = self as! FeedControllerDelegate
            }
            //if let feedController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedViewController") as? FeedViewController{
                //rootController?.pushViewController(feedController, animated: false)
            //}

        }else{
            fatalError("Could Not Instantiate Feed View Controller")
        }
        
    }
    
    func newState(state: AppState){
        if state.routing.routes[.feed]?.last != RoutingDestination.destination(ofViewController: rootController?.topViewController){
            pushViewController(state.routing.routes[.feed]?.last ?? .feed)
        }
    }
    
    func pushViewController(_ destination: RoutingDestination){
        if var viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: destination.rawValue) as? FeedController{
            viewController.delegate = self
            rootController?.pushViewController(viewController as! UIViewController, animated: true)
        }
        
    }
    
    func selectedPost(_ post: Post) {
        print("show post")
        store.dispatch(ShowPostDetail(postId: post.id))
        api.getPost(forId: post.id){post in
            store.dispatch(PostDetailResponse(post: post))
            
        }
    }
    
    func popNavigation(){
        store.dispatch(PopNavigation())
    }
    
    func getPosts(){
        api.getPosts(withQuery: ""){ posts in
            DispatchQueue.main.async {
                store.dispatch(PostResponse(posts: posts))
            }
        }
    }
    
    func subscribe(){
        store.subscribe(self)
    }
    
    func unsubscribe(){
        store.unsubscribe(self)
    }
    
    
    
}


protocol FeedController{
    var delegate: FeedControllerDelegate? { get set }
}

protocol FeedCoordinatorDelegate{
    
}


protocol FeedControllerDelegate{
    
    func selectedPost(_ post: Post)
    
    func popNavigation()
    
    func getPosts()
}


