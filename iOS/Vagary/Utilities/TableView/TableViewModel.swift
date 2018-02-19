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
    
    var sections: [SectionViewModel] { get set }
    static var cellsToRegister: [String] { get set }
}

extension TableViewModel {
    func viewModel(at indexPath: IndexPath) -> AnyCellViewModel? {
        guard indexPath.section < sections.count else { return nil }
        let section = sections[indexPath.section]
        
        guard indexPath.row < section.cells.count else { return nil }
        
        return section.cells[indexPath.row]
    }
}

protocol SectionViewModel {
    var cells: [AnyCellViewModel] { get set }
}

protocol AnyCellViewModel {
    var reuseIdentifier: String { get set }
    
    func configure(_ cell: UITableViewCell)
}

protocol CellViewModel: AnyCellViewModel {
    associatedtype CellType: UITableViewCell
    
    func configure(_ cell: CellType)
}

extension CellViewModel {
    func configure(_ cell: UITableViewCell) {
        if let specificCell = cell as? CellType {
            configure(specificCell)
        }
    }
}

protocol AnyCellActionDelegate {
    func handleCellAction(_ action: AnyCellAction, indexPath: IndexPath, data: Any?)
}

protocol CellActionDelegate: AnyCellActionDelegate {
    associatedtype CellActionType
    func handleCellAction(_ action: CellActionType, indexPath: IndexPath, data: Any?)
}

extension CellActionDelegate {
    func handleCellAction(_ action: AnyCellAction, indexPath: IndexPath, data: Any?) {
        if let specificCellAction = action as? CellActionType {
            handleCellAction(specificCellAction, indexPath: indexPath, data: data)
        }
    }
}

protocol RespondingWhenSelectedCell {
    var action: AnyCellAction? { get set }
}

protocol ActionCell {
    var action: AnyCellAction? { get set }
    var actionDelegate: AnyCellActionDelegate? { get set }
}

protocol AnyCellAction { }

class TableViewDataSource<ViewModelType: TableViewModel>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView
    var dataSource: ViewModelType
    var delegate: UITableViewDelegate?
    var cellActionDelegate: AnyCellActionDelegate?
    
    init(dataSource: ViewModelType, tableView: UITableView, cellActionDelegate: AnyCellActionDelegate? = nil, delegate: UITableViewDelegate? = nil) {
        self.tableView = tableView
        self.dataSource = dataSource
        self.cellActionDelegate = cellActionDelegate
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        for cell in ViewModelType.cellsToRegister {
            let nib = UINib(nibName: cell, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: cell)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < dataSource.sections.count else {
            return 0
        }
        let sectionCells = dataSource.sections[section]
        return sectionCells.cells.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < dataSource.sections.count,
            indexPath.row < dataSource.sections[indexPath.section].cells.count else {
                return UITableViewCell()
        }
        let vm = dataSource.sections[indexPath.section].cells[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: vm.reuseIdentifier) else {
            return UITableViewCell()
        }
        vm.configure(cell)
        if var actionCell = cell as? ActionCell {
            actionCell.actionDelegate = cellActionDelegate
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RespondingWhenSelectedCell,
            let action = cell.action {
            cellActionDelegate?.handleCellAction(action, indexPath: indexPath, data: nil)
            
        }
    }
}


struct StandardTableViewSection: SectionViewModel {
    var cells: [AnyCellViewModel]
    
    init(cells: [AnyCellViewModel]) {
        self.cells = cells
    }
}
