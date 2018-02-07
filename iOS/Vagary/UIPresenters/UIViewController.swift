//
//  UIViewController.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/7/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController: Presenter {
    func present(presenter: Presenter, animated: Bool) {
        guard let vc = presenter as? UIViewController else {
            return
        }
        self.present(vc, animated: animated, completion: nil)
    }
    
    func dismiss(animated: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
