//
//  LoginCoordinator.swift
//  Vagary
//
//  Created by Jonathan Witten on 3/6/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import PromiseKit

protocol LoginHandler {
    func login(email: String?, password: String?)
}

class LoginCoordinator: LoginHandler {
    
    let dependencies: AppDependency
    
    init(dependencies: AppDependency) {
        self.dependencies = dependencies
    }
    
    
    func login(email: String?, password: String?) {
        guard let email = email, let password = password else {
            return
        }
        
        firstly {
            dependencies.api.login(email: email, password: password)
        }.then { response -> Void in
            if response.auth {
                self.dependencies.api.set(token: response.token)
                UserDefaults.standard.set(response.refresh, forKey: "refresh")
                UserDefaults.standard.set(response.email, forKey: "email")
                ViaStore.sharedStore.dispatch(AppAction.authenticated)
            }
        }
    }
}
