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
    
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var formTableView: UITableView!
    var workingPost: Post?
    var drafts: Loaded<[Post]> = Loaded.loading
    @IBOutlet weak var tabStackView: UIStackView!
    let draftTableView = UITableView()
    
    var handler: DraftHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formTableView.delegate = self
        formTableView.dataSource = self
        let nib = UINib(nibName: "CreatePostTableViewCell", bundle: nil)
        formTableView.register(nib, forCellReuseIdentifier: "CreatePostTableViewCell")
        formTableView.rowHeight = UITableViewAutomaticDimension
        formTableView.estimatedRowHeight = 400
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ViaStore.sharedStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ViaStore.sharedStore.unsubscribe(self)
    }
    
    func editDraftDetail(field: DraftField) {
        ViaStore.sharedStore.dispatch(DraftAction.editDraftDetail(field))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newState(state: AppState) {
        self.workingPost = state.authenticatedState?.draft.workingPost
        self.drafts = state.authenticatedState?.draft.drafts ?? .error
        formTableView.reloadData()
        draftTableView.reloadData()
    }
        
    @IBAction func pressNext(_ sender: Any) {
        ViaStore.sharedStore.dispatch(createDraft())
    }
    
    func createDraft() -> Store<AppState>.ActionCreator {
        
        return { state, store in
            guard let authState = state.authenticatedState else {
                return nil
            }
            do{
                if let workingPost = authState.draft.workingPost {
                    let drafts = authState.draft.drafts
                    if case .loaded(var collection) = drafts{
                        collection.append(authState.draft.workingPost!)
                        try ViaStore.draftCache?.replace(with: collection){ success in
                            if success{
                                store.dispatch(DraftAction.createDraft(workingPost))
                            }else{
                                
                            }
                        }
                    }
                }
            }catch let error {
                print(error)
                return nil
            }
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       return getCellForFormRow(tableView: tableView, indexPath: indexPath)
    }
    
    func getCellForFormRow(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreatePostTableViewCell" , for: indexPath)
        if let cell = cell as? CreatePostTableViewCell{
            cell.detailStackView.subviews.forEach({$0.removeFromSuperview()})
            switch indexPath.row{
            case 0:
                cell.cellLabel.text = "Title"
                if workingPost?.title != nil {
                    let label = UILabel()
                    label.text = workingPost?.title
                    label.sizeToFit()
                    cell.detailStackView.addArrangedSubview(label)
                }
            case 1:
                cell.cellLabel.text = "Location"
                if workingPost?.location != nil{
                    let label = UILabel()
                    label.text = workingPost?.location
                    label.sizeToFit()
                    cell.detailStackView.addArrangedSubview(label)
                }
            case 2:
                cell.cellLabel.text = "Trip"
                if workingPost?.trip != nil{
                    let label = UILabel()
                    label.text = workingPost?.trip.title
                    label.sizeToFit()
                    cell.detailStackView.addArrangedSubview(label)
                }
            default:
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            editDraftDetail(field: .Title(title: workingPost?.title ?? ""))
        case 1:
            editDraftDetail(field: .Location(location: workingPost?.location ?? ""))
        case 2:
            editDraftDetail(field: .Trip(trip: workingPost?.trip.title ?? ""))
        default:
            break
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
