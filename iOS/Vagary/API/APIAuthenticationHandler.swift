//
//  APIAuthenticationHandler.swift
//  Vagary
//
//  Created by Jonathan Witten on 3/6/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import PromiseKit

protocol NetworkAuthProxy: APINetwork {
    var network: APINetwork { get set }
}

class APIAuthProxy: NetworkAuthProxy {
    var network: APINetwork
    
    init(network: APINetwork) {
        self.network = network
    }
    
    func request<T, R>(resource: T.Type, path: ResourcePath, requestParams: [String : String]?, requestBody: R, method: HTTPRequestType) -> Promise<T> where T : Decodable, T : Encodable, R : Decodable, R : Encodable {
        return network.request(resource: resource, path: path, requestParams: requestParams, requestBody: requestBody, method: method).recover { error -> Promise<T> in
            if let httpError = error as? PMKURLError,
                httpError.NSHTTPURLResponse.statusCode == 401,
                let token = self.getRefreshToken(),
                let email = self.getEmail() {
                return self.getNewAuthToken(email: email, refresh: token).then { response -> Promise<T> in
                        if response.auth {
                            self.network.set(header: "x-access-token", value: response.token)
                            return self.network.request(resource: resource, path: path, requestParams: requestParams, requestBody: requestBody, method: method)
                        } else {
                            return Promise(error: error)
                        }
                    }
            } else {
                return Promise(error: error)
            }
        }
    }
    
    func request<T>(resource: T.Type, path: ResourcePath, requestParams: [String : String]?, method: HTTPRequestType) -> Promise<T> where T : Decodable, T : Encodable {
        return network.request(resource: resource, path: path, requestParams: requestParams, method: method).recover { error -> Promise<T> in
            if let httpError = error as? PMKURLError,
                httpError.NSHTTPURLResponse.statusCode == 401,
                let token = self.getRefreshToken(),
                let email = self.getEmail(){
                return self.getNewAuthToken(email: email, refresh: token).then { response -> Promise<T> in
                    if response.auth {
                        self.network.set(header: "x-access-token", value: response.token)
                        return self.network.request(resource: resource, path: path, requestParams: requestParams, method: method)
                    } else {
                        return Promise(error: error)
                    }
                }
            } else {
                return Promise(error: error)
            }
        }
    }
    
    func request(url: URL, requestBody: Data, method: HTTPRequestType, contentType: String) -> Promise<Void> {
        return network.request(url: url, requestBody: requestBody, method: method, contentType: contentType).recover { error -> Promise<Void> in
            if let httpError = error as? PMKURLError,
                httpError.NSHTTPURLResponse.statusCode == 401,
                let token = self.getRefreshToken(),
                let email = self.getEmail() {
                return self.getNewAuthToken(email: email, refresh: token).then { response -> Promise<Void> in
                    if response.auth {
                        self.network.set(header: "x-access-token", value: response.token)
                        return self.network.request(url: url, requestBody: requestBody, method: method, contentType: contentType)
                    } else {
                        return Promise(error: error)
                    }
                }
            } else {
                return Promise(error: error)
            }
        }
    }
    
    func set(header: String, value: String) {
        network.set(header: header, value: value)
    }
    
    
    func getRefreshToken() -> String? {
        if let token = UserDefaults.standard.string(forKey: "refresh") {
            return token
        } else {
            return nil
        }
    }
    func getEmail() -> String? {
        return UserDefaults.standard.string(forKey: "email")
    }
    
    func getNewAuthToken(email: String, refresh: String) -> Promise<LoginResponse> {
        struct TokenRequest: Codable {
            let email: String
            let refreshToken: String
        }
        let body = TokenRequest(email: email, refreshToken: refresh)
        return network.request(resource: LoginResponse.self, path: ResourcePath.token, requestParams: nil, requestBody: body, method: .POST)
    }
    
}
