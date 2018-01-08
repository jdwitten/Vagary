//
//  Cache.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/23/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation


class Cache{
    
    
    var path: String?
    var documentsUrl: URL?
    var pathUrl: URL?

    init?(path: String){
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first as NSURL?
        self.documentsUrl = url as URL?
        if documentsUrl != nil{
            self.path = documentsUrl!.path.appending(path)
            self.pathUrl = URL(fileURLWithPath: self.path!)
        }else{
            return nil
        }
    }
    
    
    func fetch<T: Codable>(_ type: T.Type, completion: @escaping (_ data: T?) -> ()) throws{
        guard path != nil else{
            throw CacheError.FetchingError
        }
        if !FileManager.default.fileExists(atPath: path!) {
            return completion(nil)
        }
        if let data = FileManager.default.contents(atPath: path!) {
            let decoder = JSONDecoder()
            do {
                let models = try decoder.decode(type, from: data)
                return completion(models)
            } catch {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
    
    func replace<T>(with collection: [T], completion: @escaping ( _ success: Bool) -> ()) throws{
        guard path != nil, pathUrl != nil else {
            throw CacheError.InsertError
        }
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(collection)
            try data.write(to: pathUrl!, options: [.atomic])
            return completion(true)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
    
enum CacheError: Error{
   case FetchingError
   case InsertError
}
