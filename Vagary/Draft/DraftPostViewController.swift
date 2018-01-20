//
//  DraftPostViewController.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/4/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit
import ReSwift

protocol DraftPostPresenter: Presenter {
    var handler: DraftHandler? { get set }
}

class DraftPostViewController: UIViewController, StoreSubscriber, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DraftPostPresenter {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var editingModeButtons: UIStackView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    var bottomConstraint: NSLayoutConstraint?
    
    var handler: DraftHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(DraftPostViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DraftPostViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        configureBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ViaStore.sharedStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ViaStore.sharedStore.unsubscribe(self)
    }
    
    static func build(handler: DraftHandler) -> DraftPostViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DraftPostViewController") as! DraftPostViewController
        vc.handler = handler
        return vc
    }

    func configureBackButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(self.backToDetail(sender:)))
    }
    
    @objc func backToDetail(sender: AnyObject) {
        
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            buttonsBottomConstraint.constant = keyboardSize.height
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        buttonsBottomConstraint.constant = 0
        view.layoutIfNeeded()
    }
    
    
    func newState(state: AppState){
        if let viewModel = DraftPostViewModel.build(state) {
            if viewModel.content.count > self.contentView.subviews.count{
                self.appendContentElement(element: viewModel.content.last!)
            }else{
                self.layoutContent(viewModel.content)
            }
        }
    }
    
    func addNewElement(element: PostElement) {
        ViaStore.sharedStore.dispatch(DraftAction.addPostElement(element))
    }
   
    func layoutContent(_ content: [PostElement]){
        let _ = contentView.subviews.map{$0.removeFromSuperview()}
        var topConstraint = contentView.topAnchor
        let views: [UIView?] = content.map{ [unowned self] element in
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
        self.bottomConstraint = views.last!?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        NSLayoutConstraint.activate([self.bottomConstraint!])
      }
      self.view.layoutIfNeeded()
    }

    func appendContentElement(element: PostElement){
        if let newView = createBodyElement(element){
            let topView = contentView.subviews.last
            self.contentView.addSubview(newView)
            newView.translatesAutoresizingMaskIntoConstraints = false
            if bottomConstraint != nil, topView != nil {
                NSLayoutConstraint.deactivate([bottomConstraint!])
                topView!.bottomAnchor.constraint(equalTo: newView.topAnchor).isActive = true
                //newView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
            } else{
                newView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            }
            newView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
            newView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
            bottomConstraint = newView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            NSLayoutConstraint.activate([bottomConstraint!])
            if newView is UIImageView{
                newView.heightAnchor.constraint(equalToConstant: 300).isActive = true
            } else if let newView = newView as? UIScrollView{
                newView.isScrollEnabled = false
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func popNavigation(){
        
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
        else if let element = element as? UIImage{
            let imageView = UIImageView()
            imageView.image = element
            return imageView
        }
        return nil
    }
    
    @IBAction func pressPost(_ sender: Any) {
    }
    
    @IBAction func saveDraft(_ sender: Any) {
    }
    @IBAction func pressText(_ sender: Any) {
        addNewElement(element: .text(""))
    }

    @IBAction func pressImage(_ sender: Any) {
        selectPicture()
        //delegate?.addNewElement(element: URL(string: "https://www.gstatic.com/webp/gallery/1.jpg")!)
    }
    
    func selectPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            let wrapper = ImageWrapper(image: editedImage)
            addNewElement(element: .image(wrapper))
        }
        else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            let wrapper = ImageWrapper(image: possibleImage)
            addNewElement(element: .image(wrapper))
        } else {
            return
        }
        dismiss(animated: true)
    }
}

extension DraftPostViewController {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("text View change")
        ViaStore.sharedStore.dispatch(DraftAction.changeDraftText(textView.text))
    }
    
    
}
