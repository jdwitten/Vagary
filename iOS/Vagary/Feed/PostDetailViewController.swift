//
//  PostDetailViewController.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/2/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit
import ReSwift
import MarkdownView

protocol PostDetailPresenter: Presenter {
    var handler: FeedHandler? { get set }
}

class PostDetailViewController: UIViewController, StoreSubscriber, PostDetailPresenter {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var markdownView: MarkdownView?
    
    var handler: FeedHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        configureMarkdownView()
    }
    
    func configureMarkdownView() {
        markdownView = MarkdownView()
        guard let md = markdownView else { return }
        md.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(md)
        view.leadingAnchor.constraint(equalTo: md.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: md.trailingAnchor).isActive = true
        md.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        md.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViaStore.sharedStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ViaStore.sharedStore.unsubscribe(self)
    }
    
    static func build(handler: FeedHandler) -> PostDetailViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        vc.handler = handler
        return vc
    }
    
    func newState(state: AppState) {
        if let viewModel = PostViewModel.build(state),
            let post = viewModel.post {
                displayMarkdown(body: post)
        }
    }
    
    func displayMarkdown(body: String) {
        markdownView?.load(markdown: body, enableImage: true )
    }

}
