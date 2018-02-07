//
//  AppDependency.swift
//  Vagary
//
//  Created by Jonathan Witten on 1/7/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

struct AppDependency {
    let factory: PresenterFactory
    let api: APIService
    let draftCache: Cache<Draft>
}
