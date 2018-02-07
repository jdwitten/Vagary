//
//  PostFeedCover.swift
//  Travel
//
//  Created by Jonathan Witten on 7/16/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit

@IBDesignable class DesignableImage: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var cornerRadius: CGFloat = 0.0{
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    
    
}
