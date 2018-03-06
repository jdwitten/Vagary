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
    func setLayout(content: [PostElement])
}

class DraftPostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DraftPostPresenter {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var buttonsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var editingModeButtons: UIStackView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    var bottomConstraint: NSLayoutConstraint?
    
    var handler: DraftHandler?
    
    var viewModel: DraftPostViewModel?
    private var layout: [PostElement]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(DraftPostViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DraftPostViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        configureBackButton()
        if let content = layout {
           layout(content: content)
        }
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneEditing(sender:)))
    }
    
    @objc func doneEditing(sender: UIBarButtonItem) {
        handler?.finishEditingDraft(content: layout ?? [])
    }
    
    func setLayout(content: [PostElement]) {
        layout = content
    }
    
    func layout(content: [PostElement]) {
        for element in content {
            if let view = createBodyElement(element) {
                stackView.addArrangedSubview(view)
            }
        }
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
    
    func addNewElement(element: PostElement) {
        if let view = createBodyElement(element) {
            stackView.addArrangedSubview(view)
            self.view.layoutIfNeeded()
            scrollView.scrollToBottom(animated: true, offsetFromBottom: 30.0)
            if let textView = view as? UITextView {
                textView.selectedTextRange = textView.textRange(from: textView.endOfDocument, to: textView.endOfDocument)
                textView.becomeFirstResponder()
            }
        }
    }

    func createBodyElement(_ element: PostElement) -> UIView?{
        if case let .text(text) = element {
            let textView = UITextView()
            textView.isScrollEnabled = false
            textView.text = text
            textView.delegate = self
            return textView
        }
        else if case let .image(imageWrapper) = element {
            switch imageWrapper {
            case .image(let image):
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: image.size.width / image.size.height).isActive = true
                return imageView
            case .url(let url):
                if let url = URL(string: url) {
                    let imageView = UIImageView()
                    imageView.loadFromURL(url: url) { image in
                        imageView.contentMode = .scaleAspectFit
                        imageView.clipsToBounds = true
                        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: image.size.width / image.size.height).isActive = true
                    }
                    return imageView
                }
            }
        }
        return nil
    }
    
    @IBAction func pressText(_ sender: Any) {
        addNewElement(element: .text("This is some text"))
    }

    @IBAction func pressImage(_ sender: Any) {
        selectPicture()
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
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage  {
            let wrapper = DraftImage.image(editedImage)
            addNewElement(element: .image(wrapper))
            addNewElement(element: .text(""))
            handler?.addedImage(image: editedImage, at: max(0, (layout?.count ?? 0) - 1))
        } else {
            return
        }
        dismiss(animated: true)
    }
}

extension DraftPostViewController: StoreSubscriber {
    func newState(state: AppState){
        viewModel = DraftPostViewModel.build(state)
        layout = state.authenticatedState?.draft.workingPost?.content
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
        if let index = stackView.arrangedSubviews.index(of: textView) {
            handler?.updatePostElement(element: PostElement.text(textView.text), at: Int(index))
        }
    }
}


