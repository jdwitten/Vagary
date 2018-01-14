//
//  CreateDraftDetailViewController.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/22/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit
import ReSwift

protocol CreateDraftDetailPresenter: Presenter {
    var handler: DraftHandler? { get set }
}

class CreateDraftDetailViewController: UIViewController, StoreSubscriber, CreateDraftDetailPresenter {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var typeLabel: UILabel!

    var handler: DraftHandler?
    
    var field: DraftField?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViaStore.sharedStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ViaStore.sharedStore.unsubscribe(self)
    }
    

    @IBAction func pressDone(_ sender: Any) {
        if field != nil, textField.text != nil{
            switch field!{
            case .Location:
                updateDraft(field: .Location(location:textField.text!))
            case .Title:
                updateDraft(field: .Title(title:textField.text!))
            case .Trip:
                updateDraft(field:.Trip(trip:textField.text!))
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func updateDraft(field: DraftField) {
        ViaStore.sharedStore.dispatch(DraftAction.updateDraft(field))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newState(state: AppState) {
//        field = state.draft.currentlyEditing
//        if field != nil{
//            switch field!{
//            case .Location(let location):
//                typeLabel.text = "Location"
//                textField.text = location
//            case .Title(let title):
//                typeLabel.text = "Title"
//                textField.text = title
//            case .Trip(let trip):
//                typeLabel.text = "Trip"
//                textField.text = trip
//            }
//        }
    }

}
