//
//  ViewModel.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/7/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

protocol ViewModel {
    static func build(_ state: AppState) -> Self?
}
