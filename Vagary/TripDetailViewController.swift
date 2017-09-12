//
//  TripDetailViewController.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/3/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit
import ReSwift

class TripDetailViewController: UIViewController, StoreSubscriber, PassportController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    var delegate: PassportControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            delegate?.popNavigation()
        }
        store.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        let viewModel = TripViewModel(state)
        titleLabel.text = viewModel.title
        postsLabel.text = viewModel.postsTitle
    }
}
