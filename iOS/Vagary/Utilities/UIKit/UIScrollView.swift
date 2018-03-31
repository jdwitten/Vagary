//
//  UIScrollView.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/21/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    
    func scrollToBottom(animated: Bool, offsetFromBottom: CGFloat = 0) {
        let bottomOffset = (self.contentSize.height - self.bounds.height) + offsetFromBottom
        let point = CGPoint(x: 0, y: bottomOffset)
        self.setContentOffset(point, animated: animated)
    }
}
