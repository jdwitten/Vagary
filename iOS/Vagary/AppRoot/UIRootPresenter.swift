//
//  UIRootPresenter.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/7/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit

protocol RootPresenter {
    func setRoot(presenter: Presenter)
}

class UIRootPresenter: RootPresenter {
    
    func setRoot(presenter: Presenter) {
        if let vc = presenter as? UIViewController {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = vc
        }
    }
    
}
