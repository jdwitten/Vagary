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
    var createPostNavigationPresenter: NavigationPresenter?
    
    var dependencies: AppDependency
    var factory: PresenterFactory {
        return dependencies.factory
    }
    var apiService: APIService {
        return dependencies.api
    }
    
    var draftCache: Cache<Draft> {
        return dependencies.draftCache
    }
    
    init(dependencies: AppDependency){
        self.dependencies = dependencies
        rootPresenter = factory.navigationPresenter()
        rootPresenter?.push(presenter: factory.postOptionsPresenter(handler: self), animated: true)
        
    }
    
    func selectPostOption(option: PostOption) {
        switch option {
        case .drafts:
            firstly {
                draftCache.fetch()
            }.then{ drafts -> Void in
                DispatchQueue.main.async {
                    ViaStore.sharedStore.dispatch(DraftAction.loadedDrafts(.loaded(data: drafts)))
                    let draftListPresenter = self.dependencies.factory.draftListPresenter(handler: self)
                    self.rootPresenter?.push(presenter: draftListPresenter, animated: true)
                }
            }
        case .post, .images:
            firstly {
                apiService.createDraft()
            }.then{ response -> Promise<Bool> in
                ViaStore.sharedStore.dispatch(DraftAction.updateDraft(response.draft))
                return self.draftCache.insert(item: response.draft)
            }.then { success -> Void in
                return
            }
            let navPresenter = dependencies.factory.navigationPresenter()
            let createPostPresenter = dependencies.factory.createPostPresenter(handler: self)
            navPresenter.setPresenters(presenters: [createPostPresenter])
            rootPresenter?.present(presenter: navPresenter, animated: true)
            createPostNavigationPresenter = navPresenter
        }
    }
    
    func selectFieldToEdit(field: DraftField) {
        let draftDetailPresenter = factory.createDraftDetailPresenter(handler: self, field: field)
        let nav = dependencies.factory.navigationPresenter()
        nav.setPresenters(presenters: [draftDetailPresenter])
        createPostNavigationPresenter?.present(presenter: nav, animated: true)
    }
    
    func updateDraftField(field: DraftField) {
        if var draft = ViaStore.sharedStore.state.authenticatedState?.draft.workingPost {
            switch field {
            case .Location(let location): draft.location = location
            case .Title(let title): draft.title = title
            case .Trip(let trip): draft.trip?.title = trip
            }
            ViaStore.sharedStore.dispatch(DraftAction.updateDraft(draft))
            let _ = self.draftCache.replace(item: draft)
        }
    }
    
    func showDraftContent() {
        guard let draft = ViaStore.sharedStore.state.authenticatedState?.draft.workingPost else {
            return
        }
        let draftPostPresenter = self.factory.draftPostPresenter(handler: self)
        draftPostPresenter.setLayout(content: draft.content ?? [])
        self.createPostNavigationPresenter?.push(presenter: draftPostPresenter, animated: true)
    }
    
    func finishEditingDraft(content: [PostElement]) {
        ViaStore.sharedStore.dispatch(DraftAction.setContent(content))
        
        guard let draft = ViaStore.sharedStore.state.authenticatedState?.draft.workingPost else {
            return
        }
        
        firstly {
            apiService.updateDraft(draft: draft)
        }.then { response -> Void in
            self.draftCache.replace(item: draft)
            self.rootPresenter?.dismiss(animated: true)
        }.catch { error in
            // TODO: handle errors saving drafts
        }
    }
    
    func doneEditingDraftInfoDetail() {
        self.createPostNavigationPresenter?.dismiss(animated: true)
    }
}

protocol DraftHandler {
    func selectPostOption(option: PostOption)
    func selectFieldToEdit(field: DraftField)
    func updateDraftField(field: DraftField)
    func showDraftContent()
    func finishEditingDraft(content: [PostElement])
    func doneEditingDraftInfoDetail()
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
