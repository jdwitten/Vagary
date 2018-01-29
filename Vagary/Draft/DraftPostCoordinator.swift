//
//  DraftPostCoordinator.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/4/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift
import PromiseKit

class DraftPostCoordinator: DraftHandler {
    
    var rootPresenter: NavigationPresenter?
    
    var dependencies: AppDependency
    var factory: PresenterFactory {
        return dependencies.factory
    }
    var apiService: APIService {
        return dependencies.api
    }
    
    var draftCache: Cache<Post> {
        return dependencies.draftCache
    }
    
    init(dependencies: AppDependency){
        self.dependencies = dependencies
        rootPresenter = factory.navigationPresenter()
        rootPresenter?.push(presenter: factory.postOptionsPresenter(handler: self), animated: true)
        
    }
    
    func selectPostOption(option: PostOption) {
        ViaStore.sharedStore.dispatch(DraftAction.selectPostOption(option))
        let createPostPresenter = dependencies.factory.createPostPresenter(handler: self)
        rootPresenter?.push(presenter: createPostPresenter, animated: true)
    }
    
    func selectFieldToEdit(field: DraftField) {
        let draftDetailPresenter = factory.createDraftDetailPresenter(handler: self, field: field)
        rootPresenter?.push(presenter: draftDetailPresenter, animated: true)
    }
    
    func updateDraftField(field: DraftField) {
        ViaStore.sharedStore.dispatch(DraftAction.updateDraft(field))
    }
    
    func createDraft() {
        guard let post = ViaStore.sharedStore.state.authenticatedState?.draft.workingPost else {
            return
        }
        let _ = firstly {
            apiService.createDraft(title: post.title, location: post.location, trip: post.trip.title)
        }.then{ response -> Promise<Bool> in
            self.draftCache.insert(item: response.draft)
        }.then{ success -> Void in
            if success {
                let draftPostPresenter = self.factory.draftPostPresenter(handler: self)
                if let content = ViaStore.sharedStore.state.authenticatedState?.draft.workingPost?.content {
                    draftPostPresenter.setLayout(content: content)
                }
                self.rootPresenter?.push(presenter: draftPostPresenter, animated: true)
            }
        }
    }
    
    func appendDraftElement(element: PostElement) {
        ViaStore.sharedStore.dispatch(DraftAction.addPostElement(element))
    }
    
    func finishEditingDraft(content: [PostElement]) {
        ViaStore.sharedStore.dispatch(DraftAction.setContent(content))
    }
}

protocol DraftHandler {
    func selectPostOption(option: PostOption)
    func selectFieldToEdit(field: DraftField)
    func updateDraftField(field: DraftField)
    func createDraft()
    func appendDraftElement(element: PostElement)
    func finishEditingDraft(content: [PostElement])
}

enum DraftField{
    case Location(location: String)
    case Title(title: String)
    case Trip(trip: String)
}

enum PostOption {
    case images
    case post
    case drafts
}
