//
//  Store.swift
//  Vagary
//
//  Created by Jonathan Witten on 10/17/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift

class ViaStore {
    
    static let sharedStore = Store(
        reducer: AppReducer,
        state: nil
    )
    static var draftCache: Cache? = Cache(path: "drafts")
    
    private let api: TravelApi
    
    
    init() {
        api = TravelApi()
        
    }
    
    
}
