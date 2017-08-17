//
//  Protocols.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation


protocol JSONParseable{
    
    init?(json: [String: Any])
    
    func toJSON() -> [String: Any]

}

enum Loaded<T>{
    case loading
    case loaded(data: T)
    case error
}
