//
//  Cache.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/23/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import PromiseKit

protocol CacheService {
    var path: String { get set }
    func fetch() -> Promise<[CacheType]>
    func insert(item: CacheType) -> Promise<Bool>
    func replace(with collection: [CacheType]) -> Promise<Bool>
    associatedtype CacheType: Codable
}

class Cache<T: Codable>: CacheService {

    var path: String
    var documentsUrl: URL
    var pathUrl: URL
    typealias CacheType = T
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    init?(path: String){
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        self.documentsUrl = url
        self.path = documentsUrl.path.appending(path)
        self.pathUrl = URL(fileURLWithPath: self.path)
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try encoder.encode(Array<T>()).write(to: self.pathUrl)
            } catch {
                return nil
            }
        }
    }
    
    func fetch() -> Promise<[CacheType]> {
        guard FileManager.default.fileExists(atPath: path) else {
            
            return Promise(error: CacheError.FetchingError)
        }
        let queue = DispatchQueue.global(qos: .background)
        return Promise { fulfill, reject in
            queue.async {
                guard let data = FileManager.default.contents(atPath: self.path) else {
                    reject(CacheError.FetchingError)
                    return
                }
                do {
                    let models = try self.decoder.decode([CacheType].self, from: data)
                    fulfill(models)
                } catch {
                    reject(CacheError.FetchingError)
                }
            }
        }
    }
    
    func replace(with collection: [T]) -> Promise<Bool> {
        let queue = DispatchQueue.global(qos: .background)
        return Promise { fulfill, reject in
            queue.async {
                do {
                    let data = try self.encoder.encode(collection)
                    try data.write(to: self.pathUrl, options: [.atomic])
                    fulfill(true)
                } catch {
                    reject(CacheError.FetchingError)
                }
            }
        }
    }
    
    func insert(item: T) -> Promise<Bool> {
        guard FileManager.default.fileExists(atPath: path) else {
            return Promise(error: CacheError.FetchingError)
        }
        let queue = DispatchQueue.global(qos: .background)
        return Promise { fulfill, reject in
            queue.async {
                guard let data = FileManager.default.contents(atPath: self.path) else {
                    reject(CacheError.FetchingError)
                    return
                }
                do {
                    var models = try self.decoder.decode([CacheType].self, from: data)
                    models.append(item)
                    let data = try self.encoder.encode(models)
                    try data.write(to: self.pathUrl, options: [.atomic])
                    fulfill(true)
                } catch {
                    reject(CacheError.FetchingError)
                }
            }
        }
    }
}
    
enum CacheError: Error{
   case FetchingError
   case InsertError
}
