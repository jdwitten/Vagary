//
//  NavigationPresenter.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/7/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationPresenter: Presenter {
    func push(presenter: Presenter, animated: Bool)
    func pop(animated: Bool)
    func setPresenters(presenters: [Presenter])
}

extension UINavigationController: NavigationPresenter {
    func push(presenter: Presenter, animated: Bool = true) {
        guard let vc = presenter as? UIViewController else {
            return
        }
        self.pushViewController(vc, animated: animated)
    }
    
    func pop(animated: Bool) {
        self.popViewController(animated: animated)
    }
    
    func setPresenters(presenters: [Presenter]) {
        if let vcs = presenters as? [UIViewController] {
            self.setViewControllers(vcs, animated: true)
        }
    }
}

