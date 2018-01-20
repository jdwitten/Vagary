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


class FeedViewController: UIViewController, UITableViewDelegate, StoreSubscriber, UITableViewDataSource, FeedPresenter {

    
    @IBOutlet weak var postsTableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    var viewModel: FeedViewModel!
    var posts: [Post] = []
    var api = TravelApi()
    
    var handler: FeedHandler?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViaStore.sharedStore.subscribe(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("view did load")
        postsTableView.delegate = self
        postsTableView.dataSource = self
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
        let nib = UINib(nibName: "PostFeedTableViewCell", bundle: nil)
        postsTableView.register(nib, forCellReuseIdentifier: "PostFeedTableViewCell")
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
            posts = viewModel.posts
            if viewModel.loading == false{
                refreshControl.endRefreshing()
            }else{
                refreshControl.beginRefreshing()
            }
            postsTableView.reloadData()
        }
    }

}



extension FeedViewController{
    
    //func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UIScreen.main.bounds.height * 0.6
    //}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellId.PostFeed.rawValue , for: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        print("show post")
        let post = posts[indexPath.row]
//        api.get(resource: Post.self, path: .post, forId: post.id) { loadedPost in
//            switch loadedPost{
//            case .loaded(let p):
//                ViaStore.sharedStore.dispatch(FeedAction.updatePostDetail(p))
//            default:
//                break
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        handler?.updatePosts()
    }
    
    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let post = posts[indexPath.row]
        if let cell = cell as? PostFeedTableViewCell{
            cell.title.text = post.title
            //cell.postText.text = post.text
            cell.userHandle.text = String(describing: post.author)
        }
    }
    
}



