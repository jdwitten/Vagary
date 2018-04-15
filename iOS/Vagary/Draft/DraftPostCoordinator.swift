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
        firstly {
            self.uploadImage(image)
        }.then{ url -> Void in
            guard let imageURL = URL(string: url) else { return }
            ViaStore.sharedStore.dispatch(DraftAction.setCoverImage(PostImage(url: imageURL)))
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
    
    func finishEditingDraft(content: [DraftElement]) {
        when(resolved: content.flatMap { element -> Promise<String>? in
            if case .image(let postImage) = element {
                return self.uploadImage(postImage.image)
            } else {
                return nil
            }
        }).then { results -> Promise<CreatePostResponse> in
            let urls: [String] = try results.map{ result -> String in
                switch result {
                case .fulfilled(let url): return url
                case .rejected(_): throw DraftCoordinatorError.imageRequestError
                }
            }
            var urlIdx = 0
            let postContent = content.flatMap { element -> PostElement? in
                switch element {
                case .image(_):
                    guard urlIdx < urls.count, let imageURL = URL(string: urls[urlIdx]) else { return nil }
                    urlIdx += 1
                    return .image(PostImage(url: imageURL))
                case .text(let text):
                    return .text(text)
                }
            }
            ViaStore.sharedStore.dispatch(DraftAction.setContent(postContent))
            guard let draft = ViaStore.sharedStore.state.authenticatedState?.draft.workingPost else {
                    return Promise(error: DraftCoordinatorError.imageRequestError)
            }
            return self.apiService.createPost(draft: draft)
        }.then { response -> Void in
            //self.draftCache.replace(item: draft)
            self.createPostNavigationPresenter?.dismiss(animated: true)
        }.catch { error in
            // TODO: handle errors saving drafts
        }
    }
    
    func doneEditingDraftInfoDetail() {
        self.createPostNavigationPresenter?.dismiss(animated: true)
    }
    
    func uploadImage(_ image: UIImage) -> Promise<String> {
        var url: String = ""
        return firstly {
            self.apiService.getPostImageURL(fileType: "jpeg")
        }.then{ response -> Promise<Void> in
            url = response.url
            if let data = UIImageJPEGRepresentation(image, 1) {
                return self.apiService.uploadImage(to: response.signedRequest, data: data)
            } else {
                return Promise(error: DraftCoordinatorError.invalidImageData)
            }
            
        }.then { response -> Promise<String> in
            return Promise(value: url)
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
    case imageRequestError
}

protocol DraftHandler {
    func selectPostOption(option: PostOption)
    func selectFieldToEdit(field: DraftField)
    func updateDraftField(field: DraftField)
    func showCoverImageSelector()
    func showDraftContent()
    func finishEditingDraft(content: [DraftElement])
    func doneEditingDraftInfoDetail()
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
