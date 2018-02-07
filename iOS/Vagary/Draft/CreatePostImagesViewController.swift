//
//  CreatePostImagesViewController.swift
//  Vagary
//
//  Created by Jonathan Witten on 10/7/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit
protocol CreatePostImagesPresenter: Presenter {
    var handler: DraftHandler? { get set }
}
class CreatePostImagesViewController: UIViewController {
    
    var handler: DraftHandler?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
