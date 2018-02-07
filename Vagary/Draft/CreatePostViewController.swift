//
//  CreatePostViewController.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/16/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit
import ReSwift

protocol CreatePostPresenter: Presenter {
    var handler: DraftHandler? { get set }
}

class CreatePostViewController: UIViewController, StoreSubscriber, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, CreatePostPresenter {

    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    @IBOutlet weak var formTableView: UITableView!
    var workingPost: Draft?
    
    var handler: DraftHandler?
    
    static func build(handler: DraftHandler) -> CreatePostViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
        vc.handler = handler
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formTableView.delegate = self
        formTableView.dataSource = self
        let nib = UINib(nibName: "CreatePostTableViewCell", bundle: nil)
        formTableView.register(nib, forCellReuseIdentifier: "CreatePostTableViewCell")
        formTableView.rowHeight = 75
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    func newState(state: AppState) {
        self.workingPost = state.authenticatedState?.draft.workingPost
        formTableView.reloadData()
    }
        
    @IBAction func pressNext(_ sender: Any) {
        handler?.showDraftContent()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreatePostTableViewCell" , for: indexPath)
        if let cell = cell as? CreatePostTableViewCell{
            switch indexPath.row{
            case 0:
                cell.configure(field: "Title", detail: workingPost?.title)
            case 1:
                cell.configure(field: "Location", detail: workingPost?.location)
            case 2:
                cell.configure(field: "Trip", detail: workingPost?.trip?.title)
            default:
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            handler?.selectFieldToEdit(field: .Title(title: workingPost?.title ?? ""))
        case 1:
            handler?.selectFieldToEdit(field: .Location(location: workingPost?.location ?? ""))
        case 2:
            handler?.selectFieldToEdit(field: .Trip(trip: workingPost?.trip?.title ?? ""))
        default:
            break
        }
    }
}
