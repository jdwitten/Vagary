//
//  PostDetailViewController.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/2/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit
import ReSwift

class PostDetailViewController: UIViewController, StoreSubscriber {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
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
    
    func newState(state: AppState) {
        let viewModel = PostViewModel(state)
        if viewModel.post != nil{
           layoutContent(viewModel.post!)
        }
    }
    
    func configureBackButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(self.backToFeed(sender:)))
    }
    
    @objc func backToFeed(sender: AnyObject) {
        ViaStore.sharedStore.dispatch(PopNavigation())
    }
    
    func layoutContent(_ post: Post){
        contentView.subviews.map{$0.removeFromSuperview()}
        var topConstraint = contentView.topAnchor
        let body = post.content ?? []
        let views: [UIView?] = body.map{ [unowned self] element in
            if let newView = self.createBodyElement(element){
                self.contentView.addSubview(newView)
                newView.translatesAutoresizingMaskIntoConstraints = false
                newView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
                newView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
                newView.topAnchor.constraint(equalTo: topConstraint).isActive = true
                if newView is UIImageView{
                    newView.heightAnchor.constraint(equalToConstant: 400).isActive = true
                } else if let newView = newView as? UIScrollView{
                    newView.isScrollEnabled = false
                }
                
                topConstraint = newView.bottomAnchor
                return newView
            }
            return nil
        }
        if views.last != nil {
            views.last!?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }
        self.view.layoutIfNeeded()
    }
    
    func createBodyElement(_ element: PostElement) -> UIView?{
        if let element = element as? String{
            let textView = UITextView()
            textView.text = element
            return textView
        }
        else if let element = element as? URL {
            if let image = UIImageView(url: element){
                return image
            }
        }
        
        return nil
        
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
