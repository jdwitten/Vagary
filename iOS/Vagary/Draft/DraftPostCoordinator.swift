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

class DraftPostCoordinator: DraftHandler, ImageSelectorHandler {
    
    var rootPresenter: NavigationPresenter?
    var createPostNavigationPresenter: NavigationPresenter?
    
    var imageSelectorPresenter: ImageSelectorPresenter?
    
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
    
    func showCoverImageSelector() {
        let controller = self.factory.imageSelectorPresenter(handler: self)
        guard let createPostPresenter = createPostNavigationPresenter?.topPresenter else {
            return
        }
        imageSelectorPresenter = controller
        controller.presentImagePicker(on: createPostPresenter)
        
    }
    
    func selectCoverImage(image: UIImage) {
        var url: String = ""
        ViaStore.sharedStore.dispatch(DraftAction.setCoverImage(DraftImage.image(image)))
        firstly {
            self.apiService.getPostImageURL(fileType: "jpeg")
        }.then{ response -> Promise<Void> in
            url = response.url
            if let data = UIImageJPEGRepresentation(image, 1) {
                return self.apiService.uploadImage(to: response.signedRequest, data: data)
            } else {
                return Promise(error: DraftCoordinatorError.invalidImageData)
            }
        }.then { response -> Void in
            ViaStore.sharedStore.dispatch(DraftAction.setCoverImage(DraftImage.url(url)))
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
        
        guard let draft = ViaStore.sharedStore.state.authenticatedState?.draft.workingPost,
            let markdown = draft.markdown,
            let title = draft.title,
            let trip = draft.trip,
            let location = draft.location else {
            return
        }
        let renderablePost = Post(id: draft.id, author: draft.author, body: markdown, title: title, trip: trip , location: location)
        firstly {
            apiService.createPost(draft: draft)
        }.then { response -> Void in
            self.draftCache.replace(item: draft)
            self.createPostNavigationPresenter?.dismiss(animated: true)
        }.catch { error in
            // TODO: handle errors saving drafts
        }
    }
    
    func doneEditingDraftInfoDetail() {
        self.createPostNavigationPresenter?.dismiss(animated: true)
    }
    
    func addedImage(image: UIImage, at index: Int)  {
        var url: String = ""
        appendDraftElement(element: PostElement.image(.image(image)))
        ViaStore.sharedStore.dispatch(DraftAction.appendDraftElement(.text("")))
        firstly {
            self.apiService.getPostImageURL(fileType: "jpeg")
        }.then{ response -> Promise<Void> in
            url = response.url
            if let data = UIImageJPEGRepresentation(image, 1) {
                return self.apiService.uploadImage(to: response.signedRequest, data: data)
            } else {
                return Promise(error: DraftCoordinatorError.invalidImageData)
            }
        }.then { response -> Void in
            ViaStore.sharedStore.dispatch(DraftAction.updateElement(PostElement.image(DraftImage.url(url)), index))
        }
    }
    
    func appendDraftElement(element: PostElement) {
        ViaStore.sharedStore.dispatch(DraftAction.appendDraftElement(element))
    }
    
    func updatePostElement(element: PostElement, at index: Int) {
        ViaStore.sharedStore.dispatch(DraftAction.updateElement(element, index))
    }
}

enum DraftCoordinatorError: Error {
    case invalidImageData
}

protocol DraftHandler {
    func selectPostOption(option: PostOption)
    func selectFieldToEdit(field: DraftField)
    func updateDraftField(field: DraftField)
    func showCoverImageSelector()
    func showDraftContent()
    func finishEditingDraft(content: [PostElement])
    func doneEditingDraftInfoDetail()
    func addedImage(image: UIImage, at index: Int)
    func appendDraftElement(element: PostElement)
    func updatePostElement(element: PostElement, at index: Int)
    func selectCoverImage(image: UIImage)
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
