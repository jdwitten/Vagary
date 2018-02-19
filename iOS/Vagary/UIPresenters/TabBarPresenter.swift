//
//  TabBarPresenter.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/7/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarPresenter: Presenter {
    var presenters: [Presenter]? { get set }
}

extension UITabBarController: TabBarPresenter {
    var presenters: [Presenter]? {
        get {
            return self.viewControllers
        } set(newPresenters) {
            self.viewControllers = newPresenters as? [UIViewController]
        }
    }
    
    static func configureAppearance() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
