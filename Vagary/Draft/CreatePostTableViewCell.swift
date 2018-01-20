//
//  CreatePostTableViewCell.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/22/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit

class CreatePostTableViewCell: UITableViewCell {

    
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var horizontalStackView: UIStackView!
    
    func configure(field: String, detail: String?) {
        for label in verticalStackView.subviews {
            verticalStackView.removeArrangedSubview(label)
            label.removeFromSuperview()
        }
        let fieldLabel = UILabel()
        fieldLabel.font = UIFont.boldSystemFont(ofSize: 14)
        fieldLabel.text = field
        verticalStackView.addArrangedSubview(fieldLabel)
        
        if let d = detail {
            let detailLabel = UILabel()
            detailLabel.font = UIFont.boldSystemFont(ofSize: 14)
            detailLabel.text = d
            detailLabel.textColor = UIColor.gray
            verticalStackView.addArrangedSubview(detailLabel)
        }
    }
    
}
