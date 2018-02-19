//
//  DraftListViewModel.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/29/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation

struct DraftListViewModel: TableViewModel {
    var sections: [SectionViewModel]
    static var cellsToRegister: [String] = []
    
    static func build(_ state: AppState) -> DraftListViewModel? {
        guard let drafts = state.authenticatedState?.draft.drafts else {
            return nil
        }
        var cells: [DraftCellViewModel] = []
        switch drafts {
        case .loading, .error:
            return nil
        case .loaded(let loadedDrafts):
            cells = loadedDrafts.map{ DraftCellViewModel(title: $0.title ?? "")}
        }
        return DraftListViewModel(sections: [StandardTableViewSection(cells: cells)])
    }
}
