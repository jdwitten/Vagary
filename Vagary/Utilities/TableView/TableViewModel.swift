//
//  TableViewModel.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/20/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation

protocol TableViewModel {
    
    var sections: [SectionViewModel]?
}

protocol SectionViewModel {
    var cells: [CellViewModel]?
}

protocol CellViewModel {
    var reuseIdentifier: String
    
    func configure(_ cell: UITableViewCell)
}
