//
//  Route.swift
//  Vagary
//
//  Created by Jonathan Witten on 10/16/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

enum RoutingDestination: String{
    case feed = "FeedViewController"
    case passport = "PassportViewController"
    case postDetail = "PostDetailViewController"
    case tripDetail = "TripDetailViewController"
    case draftPost = "DraftPostViewController"
    case createPost = "CreatePostViewController"
    case editDraftDetail = "CreateDraftDetailViewController"
    case postOptions = "PostOptionsViewController"
    case createPostImages = "CreatePostImagesViewController"
    case draftList = "DraftListViewController"
    
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
        else if viewController is CreatePostViewController{
            return .createPost
        }
        else if viewController is CreateDraftDetailViewController{
            return .editDraftDetail
        }
        else if viewController is PostOptionsViewController {
            return .postOptions
        }
        else if viewController is DraftListViewController {
            return .draftList
        }
        else{
            return nil
        }
    }
    
    var viewController: UIViewController {
        switch self{
        case .feed: return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        case .passport: return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PassportViewController") as! PassportViewController
        case .postDetail: return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        case .tripDetail: return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TripDetailViewController") as! TripDetailViewController
        case .draftPost: return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DraftPostViewController") as! DraftPostViewController
        case .createPost: return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
        case .editDraftDetail: return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateDraftDetailViewController") as! CreateDraftDetailViewController
        case .postOptions: return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostOptionsViewController") as! PostOptionsViewController
        case .createPostImages: return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreatePostImagesViewController") as! CreatePostImagesViewController
        case .draftList: return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DraftListViewController") as! DraftListViewController
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
