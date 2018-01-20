//
//  CenteredImageTableViewCell.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/20/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import UIKit

class CenteredImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var centeredImage: UIImageView!
    
}

struct CenteredImageCellViewModel: CellViewModel {
    var reuseIdentifier: String? = "CenteredImageTableViewCell"
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    func configure(_ cell: CenteredImageTableViewCell) {
        cell.centeredImage.image = self.image
    }
    
}


