//
//  DraftPostViewController.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/4/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit
import ReSwift

class DraftPostViewController: UIViewController, StoreSubscriber, DraftPostController, UITextViewDelegate {

    @IBOutlet weak var buttonsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var editingModeButtons: UIStackView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    var delegate: DraftPostControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(DraftPostViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DraftPostViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification:NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            buttonsBottomConstraint.constant = keyboardSize.height
            view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification:NSNotification){
        buttonsBottomConstraint.constant = 0
        view.layoutIfNeeded()
    }
    
    
    func newState(state: AppState){
        
        let viewModel = DraftPostViewModel(state)
        if viewModel.post != nil {
            layoutContent(viewModel.post!)
        }
    }
    
    func layoutContent(_ post: Post){
        var topConstraint = self.view.topAnchor
        
        let body = post.content
    
        let views: [UIView?] = body.map{ [unowned self] element in
            if let newView = self.createBodyElement(element){
                newView.topAnchor.constraint(equalTo: topConstraint).isActive = true
                topConstraint = newView.bottomAnchor
                self.view.addSubview(newView)
                return newView
            }
            return nil
        }
        
    }
    
    func createBodyElement(_ element: PostElement) -> UIView?{
        if let element = element as? String{
            let textView = UITextView()
            textView.text = element
            textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            textView.trailingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            return textView
        }
        else if let element = element as? URL {
            if let image = UIImageView(url: element){
                image.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
                image.trailingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
                image.heightAnchor.constraint(equalToConstant: 400).isActive = true
                return image
            }
        }
        
        return nil
        
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

extension DraftPostViewController{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("text View change")
        store.dispatch(ChangeDraftText(newText: textView.text))
    }
    
    
}
