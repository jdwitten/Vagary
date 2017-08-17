//
//  FeedViewController.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit
import ReSwift




class FeedViewController: UIViewController, UITableViewDelegate, StoreSubscriber, UISearchBarDelegate, UITableViewDataSource {

    
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: FeedViewModel!
    let api: TravelApi = TravelApi()
    var posts: [Post] = []

    
    //let activityIndicator = ActivityIndicator()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        postsTableView.delegate = self
        searchBar.delegate = self
        postsTableView.dataSource = self
    }
    
    
    func getPosts(with query: String) -> Store<AppState>.ActionCreator {
        
        return { state, store in
            TravelApi.getPosts(withQuery: state.feed.query ?? ""){ posts in
                DispatchQueue.main.async {
                    store.dispatch(PostResponse(posts: posts))
                }
            }
            
            return PostSearch(query: query)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newState(state: AppState){
        let viewModel = FeedViewModel(state)
        posts = viewModel.posts
        print(posts)
        postsTableView.reloadData()
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



extension FeedViewController{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellId.PostFeed.rawValue , for: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        store.dispatch(getPosts(with: searchText))
    }
    
    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let post = posts[indexPath.row]
        if let cell = cell as? PostFeedTableViewCell{
            cell.title.text = post.title
            cell.postText.text = post.text
            cell.userHandle.text = String(describing: post.author)
        }
    }
    
}



