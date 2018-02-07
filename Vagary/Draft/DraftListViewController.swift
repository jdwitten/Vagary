//
//  DraftListViewController.swift
//  Vagary
//
//  Created by Jonathan Witten on 10/7/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit
import ReSwift

protocol DraftListPresenter: Presenter {
    var handler: DraftHandler? { get set }
}

class DraftListViewController: UITableViewController, StoreSubscriber, DraftListPresenter {
    var viewModel: DraftListViewModel?

    var handler: DraftHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "DraftTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DraftTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static func build(handler: DraftHandler) -> DraftListViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DraftListViewController") as! DraftListViewController
        vc.handler = handler
        return vc
    }
    
    func configureBackButton() {
    }
    
    
    func newState(state: AppState) {
        guard let vm = DraftListViewModel.build(state) else {
            return
        }
        self.viewModel = vm
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let vmSection = viewModel?.sections?[section] {
            return vmSection.cells?.count ?? 0
        } else {
            return 0
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DraftTableViewCell", for: indexPath) as! DraftTableViewCell
        viewModel?.sections?[indexPath.section].cells?[indexPath.row].configure(cell)
        return cell
    }

}
