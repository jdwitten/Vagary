//
//  FeedViewController.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit
import ReSwift

protocol FeedPresenter: Presenter {
    var handler: FeedHandler? { get set }
}


class FeedViewController: UIViewController, UITableViewDelegate, StoreSubscriber, FeedPresenter {

    
    @IBOutlet weak var postsTableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    var dataSource: TableViewDataSource<FeedViewModel>!
    var posts: [Post] = []
    
    var handler: FeedHandler?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViaStore.sharedStore.subscribe(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("view did load")
        dataSource = TableViewDataSource(dataSource: FeedViewModel(sections: [], query: "", loading: false),
                                         tableView: postsTableView,
                                         cellActionDelegate: self,
                                         delegate: self)
        
        configureTableView()
        
        handler?.updatePosts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ViaStore.sharedStore.unsubscribe(self)
    }
    
    static func build(handler: FeedHandler) -> FeedViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        vc.handler = handler
        return vc
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView(){
        postsTableView.rowHeight = UITableViewAutomaticDimension
        postsTableView.estimatedRowHeight = 400
        self.refreshControl.addTarget(self, action: #selector(FeedViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        postsTableView.addSubview(refreshControl)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl){
        handler?.updatePosts()
    }
    
    func newState(state: AppState){
        if let viewModel = FeedViewModel.build(state) {
            if viewModel.loading == false {
                refreshControl.endRefreshing()
            }else{
                refreshControl.beginRefreshing()
            }
            dataSource.dataSource = viewModel
            postsTableView.reloadData()
        }
    }
}

extension FeedViewController: CellActionDelegate {
    func handleCellAction(_ action: FeedCellAction, indexPath: IndexPath, data: Any?) {
        switch action {
        case .selectPost:
            if let post = self.dataSource.dataSource.viewModel(at: indexPath) as? PostCellViewModel {
                handler?.viewPost(post: post.postText)
            }
            
        }
    }
}
