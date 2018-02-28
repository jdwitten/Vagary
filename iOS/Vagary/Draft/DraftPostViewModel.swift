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
    
    var sections: [SectionViewModel]
    static var cellsToRegister: [String] = []
    
    static func build(_ state: AppState) -> DraftPostViewModel? {
        guard let auth = state.authenticatedState else {
            return nil
        }
        let cells: [AnyCellViewModel]? = auth.draft.workingPost?.content?.flatMap{ element in
            if case .image(let imageWrapper) = element {
//                return CenteredImageCellViewModel(image: imageWrap)
                return nil
            } else if case .text(let text) = element {
                return CenteredTextCellViewModel(text: text)
            } else {
                return nil
            }
        }
        
        let section = StandardTableViewSection(cells: cells ?? [])
        return DraftPostViewModel(sections: [section])
    }
}
