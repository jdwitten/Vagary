//
//  CreateTripViewController.swift
//  Vagary
//
//  Created by Jonathan Witten on 3/26/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import UIKit
import ReSwift


protocol CreateTripHandler {
    func showImageSelector()
    func submitNewTrip(with title: String)
}
protocol CreateTripPresenter: Presenter {
    var handler: CreateTripHandler? { get }
}

class CreateTripViewController: UIViewController, CreateTripPresenter, StoreSubscriber  {

    @IBOutlet weak var tripTitleTextField: UITextField!
    @IBOutlet weak var tripImageButton: UIButton!
    var handler: CreateTripHandler?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(CreateTripViewController.createTrip))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViaStore.sharedStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ViaStore.sharedStore.unsubscribe(self)
    }
    
    static func build(handler: CreateTripHandler) -> CreateTripPresenter {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTripViewController") as! CreateTripViewController
        vc.handler = handler
        return vc
    }
    
    @IBAction func pressCoverImage(_ sender: Any) {
        handler?.showImageSelector()
    }
    
    @objc func createTrip() {
        handler?.submitNewTrip(with: tripTitleTextField.text ?? "")
    }
    
    
    func newState(state: AppState) {
        if let covIm = state.authenticatedState?.passport.newTripImage {
            let _ = UIImage.build(with: covIm).then { image in
                DispatchQueue.main.async { self.tripImageButton.setImage(image, for: .normal) }
            }
        } else {
            self.tripImageButton.setImage(nil, for: .normal)
        }
        tripTitleTextField.text = state.authenticatedState?.passport.newTripTitle
    }


}
