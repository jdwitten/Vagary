
//
//  FeedCoordinator.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift
import PromiseKit


class FeedCoordinator: FeedHandler {
    
    let dependencies: AppDependency
    let rootPresenter: NavigationPresenter
    
    init(dependencies: AppDependency){
        self.dependencies = dependencies
        rootPresenter = dependencies.factory.navigationPresenter()
        rootPresenter.push(presenter: dependencies.factory.feedPresenter(handler: self), animated: true)
    }
    
    func updatePosts() {
        let _ = firstly {
            dependencies.api.getPosts()
        }.then { response in
            ViaStore.sharedStore.dispatch(FeedAction.updatePosts(.loaded(data: response.posts)))
        }.catch{ error in
            ViaStore.sharedStore.dispatch(FeedAction.updatePosts(.error))
        }
    }
    
    func viewPost(post: String) {
        ViaStore.sharedStore.dispatch(FeedAction.selectPost(post))
        let postPresenter = dependencies.factory.postDetailPresenter(handler: self)
        rootPresenter.push(presenter: postPresenter, animated: true)
    }
}

protocol FeedHandler {
    func updatePosts()
    func viewPost(post: String)
}



