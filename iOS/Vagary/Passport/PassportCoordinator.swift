//
//  PassportCoordinator.swift
//  Vagary
//
//  Created by Jonathan Witten on 8/20/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift
import PromiseKit

class PassportCoordinator: PassportHandler {
    
    var rootPresenter: NavigationPresenter?
    var addTripNavigationPresenter: NavigationPresenter?
    var imagePickerPresenter: ImageSelectorPresenter?
    let dependencies: AppDependency
    var factory: PresenterFactory {
        return dependencies.factory
    }
    var apiService: APIService {
        return dependencies.api
    }
    
    init(dependencies: AppDependency){
        self.dependencies = dependencies
        rootPresenter = factory.navigationPresenter()
        rootPresenter?.push(presenter: factory.passportPresenter(handler: self), animated: true)
    }
    
    func updateTrips() {
        let _ = firstly {
            dependencies.api.getTrips()
        }.then { response -> Void in
            ViaStore.sharedStore.dispatch(PassportAction.tripsResponse(.loaded(data: response.trips)))
        }.catch{ error in
            ViaStore.sharedStore.dispatch(PassportAction.tripsResponse(.error))
        }
    }
    
    func addTrip() {
        let presenter = factory.createTripPresenter(handler: self)
        addTripNavigationPresenter = factory.navigationPresenter()
        addTripNavigationPresenter?.push(presenter: presenter, animated: true)
        if let nav = addTripNavigationPresenter {
           rootPresenter?.present(presenter: nav, animated: true)
        }
    }
}

extension PassportCoordinator: CreateTripHandler, ImageSelectorHandler {

    func showImageSelector() {
        let presenter = self.factory.imageSelectorPresenter(handler: self)
        imagePickerPresenter = presenter
        guard let nav = addTripNavigationPresenter else { return }
        presenter.presentImagePicker(on: nav)
    }
    
    func selectCoverImage(image: UIImage) {
        var url: String = ""
        ViaStore.sharedStore.dispatch(PassportAction.setNewTripImage(DraftImage.image(image)))
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
            ViaStore.sharedStore.dispatch(PassportAction.setNewTripImage(DraftImage.url(url)))
        }
    }
    
    func submitNewTrip(with title: String) {
        ViaStore.sharedStore.dispatch(PassportAction.setNewTripTitle(title))
        guard let title = ViaStore.sharedStore.state.authenticatedState?.passport.newTripTitle,
            let image = ViaStore.sharedStore.state.authenticatedState?.passport.newTripImage else {
                return
        }
        if case .url(let url) = image {
            let _ = apiService.createTrip(title: title, image: url).then { response -> Void in
                if response.success {
                    self.rootPresenter?.dismiss(animated: true)
                }
            }
        }
    }
}

protocol PassportHandler {
    func updateTrips()
    func addTrip()
}

