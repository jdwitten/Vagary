//
//  TableViewModel.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/20/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewModel {
    
    var sections: [SectionViewModel]? { get set }
}

protocol SectionViewModel {
    var cells: [CellViewModel]? { get set }
}

protocol CellViewModel {
    var reuseIdentifier: String { get set }
    
    func configure(_ cell: UITableViewCell)
}
