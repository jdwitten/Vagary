//
//  DraftPostViewModel.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/4/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift


struct DraftPostViewModel: ViewModel, TableViewModel {
    
    var sections: [SectionViewModel]?
    
    static func build(_ state: AppState) -> DraftPostViewModel? {
        guard let auth = state.authenticatedState else {
            return nil
        }
        let cells: [CellViewModel] = auth.draft.content.map{ element in
            if case .image(let imageWrapper) = element {
                return CenteredImageCellViewModel(image: imageWrapper.image)
            } else if case .text(let text) = element {
                return CenteredTextCellViewModel(text: text)
            } else {
                return nil
            }
        }
        
        let section = DraftContentSection(cells: cells)
        return DraftPostViewModel(sections: [section])
    }
}

struct DraftContentSection: SectionViewModel {
    var cells: [CellViewModel]?
    
    init(cells: [CellViewModel]) {
        self.cells = cells
    }
}
