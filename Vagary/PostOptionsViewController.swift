//
//  PostOptionsViewController.swift
//  Vagary
//
//  Created by Jonathan Witten on 10/6/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit

class PostOptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func writePostPress(_ sender: Any) {
        ViaStore.sharedStore.dispatch(SelectPostOption(option: .createPost))
    }
    
    @IBAction func shareImagesPress(_ sender: Any) {
        ViaStore.sharedStore.dispatch(SelectPostOption(option: .createPostImages))
    }
    @IBAction func openDrafts(_ sender: Any) {
        ViaStore.sharedStore.dispatch(SelectPostOption(option: .draftList))
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
