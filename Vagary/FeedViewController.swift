//
//  FeedViewController.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources




class FeedViewController: UIViewController, UITableViewDelegate {

    
    @IBOutlet weak var postsTableView: UITableView!
    let refreshControl = UIRefreshControl()
    var viewModel: FeedViewModel!
    var disposeBag = DisposeBag()
    let dataSource = FeedViewController.configureDataSource()
    
    //let activityIndicator = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel = FeedViewModel()
        
        postsTableView.addSubview(refreshControl)
        
        refreshControl.rx
            .controlEvent(.valueChanged)
            .asObservable()
            .map{true}
            .bindTo(viewModel.refresh)
            .disposed(by: disposeBag)
    
       viewModel
            .Posts
            .map{ [SectionModel(model: "", items:$0)] }
            .drive( postsTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel
            .Posts
            .map{ _ in false }
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        postsTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
    }
    
    static func configureDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, Post>>{
    
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Post>>()
        
        dataSource.configureCell = { (_, tv, ip, post: Post) in
            let cell = tv.dequeueReusableCell(withIdentifier: TableViewCellId.PostFeed.rawValue)! as! PostFeedTableViewCell
            cell.title.text = post.title
            cell.userHandle.text = String(describing: post.author)
            cell.postText.text = post.text
            return cell
        }
        
        
        return dataSource
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
}

