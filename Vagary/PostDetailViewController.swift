//
//  PostDetailViewController.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/2/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit
import ReSwift

class PostDetailViewController: UIViewController, StoreSubscriber, FeedController {

    var delegate: FeedControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            delegate?.popNavigation()
        }
        store.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        let viewModel = PostViewModel(state)
        if viewModel.post != nil{
           layoutContent(viewModel.post!)
        }
    }
    
    func layoutContent(_ post: Post){
        var topConstraint = self.view.topAnchor
        
        let body = post.content
        
        let views: [UIView?] = body.map{ [unowned self] element in
            if let newView = self.createBodyElement(element){
                self.view.addSubview(newView)
                newView.translatesAutoresizingMaskIntoConstraints = false
                newView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
                newView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
                newView.topAnchor.constraint(equalTo: topConstraint).isActive = true
                newView.heightAnchor.constraint(equalToConstant: 400).isActive = true
                topConstraint = newView.bottomAnchor
                return newView
            }
            return nil
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
