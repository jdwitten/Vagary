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
    var headers: [String: String] = [:]
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func request<T: Codable, R: Codable>(resource: T.Type, path: ResourcePath, requestParams: [String: String]? = nil, requestBody: R, method: HTTPRequestType) -> Promise<T> {
        do {
            let urlPath = baseURL + "/\(path.rawValue)" + getParamString(params: requestParams)
            if let url = URL(string: urlPath) {
                var request = URLRequest(url: url)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONEncoder().encode(requestBody)
                request.httpMethod = method.rawValue
                print(requestBody)
                return send(request: request)
            } else {
                return Promise(error: APIError.apiError)
            }
        } catch let error {
            return Promise(error: error)
        }
    }

    func request<T: Codable>(resource: T.Type, path: ResourcePath, requestParams: [String: String]? = nil, method: HTTPRequestType) -> Promise<T> {
        let urlPath = baseURL + "/\(path.rawValue)" + getParamString(params: requestParams)
        if let url = URL(string: urlPath) {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            return send(request: request)
        } else {
            return Promise(error: APIError.apiError)
        }
    }
    
    func request(url: URL, requestBody: Data, method: HTTPRequestType, contentType: String) -> Promise<Void> {
        return firstly { () -> Promise<(Data, URLResponse)> in
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.httpBody = requestBody
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            for (key, value) in headers { request.setValue(key, forHTTPHeaderField: value)}
            return URLSession.shared.dataTask(with: request).asDataAndResponse()
        }.then { data, response in
            return Promise()
        }
    }
    
    func set(header: String, value: String) {
        headers[header] = value
    }


    private func send<T: Codable>(request: URLRequest) -> Promise<T> {
        var request = request
        for (key, value) in headers { request.setValue(value, forHTTPHeaderField: key)}
        return firstly {
            return URLSession.shared.dataTask(with: request).asDataAndResponse()
        }.then { (data, response) -> Promise<T> in
            let objects = try JSONDecoder().decode(T.self, from: data)
            return Promise(value: objects)
        }
    }
    
    private func getParamString(params: [String:String]?) -> String {
        var paramString = ""
        guard let params = params else {
            return paramString
        }
        paramString += "?"
        var firstParam = true
        for (key, value) in params {
            if !firstParam { paramString += "&" }
            paramString += "\(key)=\(value)"
            firstParam = false
        }
        return paramString
    }
}
