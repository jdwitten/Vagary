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

class DraftListViewController: UITableViewController, StoreSubscriber{
    var drafts: [Post] = [Post]()

    var handler: DraftHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        let nib = UINib(nibName: "DraftTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DraftTableViewCell")
        configureBackButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViaStore.sharedStore.subscribe(self)
        reloadDrafts()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ViaStore.sharedStore.unsubscribe(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureBackButton() {
    }
    
    
    func newState(state: AppState) {
        guard let auth = state.authenticatedState else {
            return
        }
        let newDrafts = auth.draft.drafts
        switch newDrafts{
        case .loaded(let data):
            drafts = data
        case .loading:
            break
        case .error:
            drafts = []
        }
        tableView.reloadData()
    }
    
    func reloadDrafts(){
        DispatchQueue.main.async{
            do{
                try ViaStore.draftCache?.fetch([Post].self){ data in
                    if data != nil{
                        ViaStore.sharedStore.dispatch(DraftAction.loadedDrafts(.loaded(data: data!)))
                    }else{
                        ViaStore.sharedStore.dispatch(DraftAction.loadedDrafts(.loaded(data: [])))
                    }
                }
            }catch let error {
                print(error)
                ViaStore.sharedStore.dispatch(DraftAction.loadedDrafts(.error))
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return drafts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DraftTableViewCell", for: indexPath) as! DraftTableViewCell
        cell.titleLabel.text = drafts[indexPath.row].title
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
