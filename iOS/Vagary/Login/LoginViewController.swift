//
//  LoginPresenter.swift
//  Vagary
//
//  Created by Jonathan Witten on 3/6/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit
import ReSwift

protocol LoginPresenter: Presenter {
    var handler: LoginHandler? { get set }
}

class LoginViewController: UIViewController, LoginPresenter {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    var handler: LoginHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViaStore.sharedStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ViaStore.sharedStore.unsubscribe(self)
    }
    
    static func build(handler: LoginHandler) -> LoginPresenter {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.handler = handler
        return vc
    }
    
    @IBAction func pressedSubmit(_ sender: Any) {
        handler?.login(email: emailField.text, password: passwordField.text)
    }
}

extension LoginViewController: StoreSubscriber {
    func newState(state: AppState) {
        
    }
}
