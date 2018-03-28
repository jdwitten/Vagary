//
//  ImageSelectorPresenter.swift
//  Vagary
//
//  Created by Jonathan Witten on 3/3/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit

protocol ImageSelectorPresenter {
    var handler: ImageSelectorHandler? { get }
    func presentImagePicker(on controller: Presenter)
}
protocol ImageSelectorHandler {
    func selectCoverImage(image: UIImage)
}

class ImageSelectorController: UIViewController, ImageSelectorPresenter, UINavigationControllerDelegate {
    var handler: ImageSelectorHandler?
    var rootController: Presenter?
    
    static func build(handler: ImageSelectorHandler) -> ImageSelectorPresenter {
        let vc = ImageSelectorController()
        vc.handler = handler
        return vc
    }
    
    func presentImagePicker(on controller: Presenter) {
        rootController = controller
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        rootController?.present(presenter: picker, animated: true)
    }
}

extension ImageSelectorController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        rootController?.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage  {
            handler?.selectCoverImage(image: editedImage)
        } else {
            return
        }
        rootController?.dismiss(animated: true)
    }
}
