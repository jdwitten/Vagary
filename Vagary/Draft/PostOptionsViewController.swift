//
//  PostOptionsViewController.swift
//  Vagary
//
//  Created by Jonathan Witten on 10/6/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit

protocol PostOptionsPresenter: Presenter {
    var handler: DraftHandler? { get set }
}

class PostOptionsViewController: UIViewController, PostOptionsPresenter {

    var handler: DraftHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static func build(handler: DraftHandler) -> PostOptionsViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostOptionsViewController") as! PostOptionsViewController
        vc.handler = handler
        return vc
    }
    
    @IBAction func writePostPress(_ sender: Any) {
        ViaStore.sharedStore.dispatch(DraftAction.selectPostOption(.post))
    }
    
    @IBAction func shareImagesPress(_ sender: Any) {
        ViaStore.sharedStore.dispatch(DraftAction.selectPostOption(.images))
    }
    @IBAction func openDrafts(_ sender: Any) {
        ViaStore.sharedStore.dispatch(DraftAction.selectPostOption(.drafts))
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
