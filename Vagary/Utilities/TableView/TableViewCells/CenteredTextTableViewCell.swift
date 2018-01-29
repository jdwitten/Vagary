//
//  CenteredTextTableViewCell.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/20/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import UIKit

class CenteredTextTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
}

struct CenteredTextCellViewModel: CellViewModel {
    var text: String?
    var reuseIdentifier: String = "CenteredTextTableViewCell"
    
    init(text: String) {
        self.text = text
    }
    
    func configure(_ cell: UITableViewCell) {
        guard let cell = cell as? CenteredTextTableViewCell else {
            return
        }
        cell.label.text = text
    }
}
