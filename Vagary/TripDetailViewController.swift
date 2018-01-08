//
//  TripDetailViewController.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/3/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit
import ReSwift

class TripDetailViewController: UIViewController, StoreSubscriber {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViaStore.sharedStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ViaStore.sharedStore.unsubscribe(self)
    }
    
    func configureBackButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(self.backToPassport(sender:)))
    }
    
    @objc func backToPassport(sender: AnyObject) {
        ViaStore.sharedStore.dispatch(PopNavigation())
    }
    
    func newState(state: AppState) {
        let viewModel = TripViewModel(state)
        titleLabel.text = viewModel.title
        postsLabel.text = viewModel.postsTitle
    }
}
