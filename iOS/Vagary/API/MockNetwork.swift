//
//  MockNetwork.swift
//  Vagary
//
//  Created by Jonathan Witten on 2/6/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import PromiseKit

class MockNetwork: APINetwork {
    
    func request<T: Codable>(resource: T.Type, path: ResourcePath) -> Promise<T> {
        return firstly {
            getJsonData(path.rawValue)
        }.then { response -> Promise<T> in
            let objects = try JSONDecoder().decode(T.self, from: response)
            return Promise(value: objects)
        }
    }
    
    
    private func getJsonData(_ path: String) -> Promise<Data> {
        do {
            if let file = Bundle.main.url(forResource: path, withExtension: "json"){
                let data = try Data(contentsOf: file)
                return Promise(value: data)
            }else{
                throw APIError.apiError
            }
        }catch let error {
            return Promise(error: error)
        }
    }
}
