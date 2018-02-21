//
//  Network.swift
//  Vagary
//
//  Created by Jonathan Witten on 2/6/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import PromiseKit

class Network: APINetwork {
    let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func request<T: Codable>(resource: T.Type, path: ResourcePath, requestParams: [String: String]? = nil) -> Promise<T> {
        return firstly { () -> Promise<(Data, URLResponse)> in
            let urlPath = baseURL + "/\(path.rawValue)"
            if let url = URL(string: urlPath) {
                let request = URLRequest(url: url)
                return URLSession.shared.dataTask(with: request).asDataAndResponse()
            } else {
                return Promise(error: APIError.apiError)
            }
        }.then { (data, response) -> Promise<T> in
            let objects = try JSONDecoder().decode(T.self, from: data)
            return Promise(value: objects)
        }
    }
}
