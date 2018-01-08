//
//  TravelApi.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation

class TravelApi{
    
    
    func get<T: Codable>(resource: T.Type, path: ResourcePath, forId id: Int, completion: @escaping (Loaded<T>) -> ()){
        let jsonData = getJsonData(path.rawValue)
        do {
            if jsonData != nil{
                let parsed = try JSONDecoder().decode(T.self, from: jsonData!)
                completion(.loaded(data: parsed))
            }
            else{
                completion(.error)
            }
        }catch{
            completion(.error)
        }
    }
    
    func getMany<T: Codable>(resource: T.Type, path: ResourcePath, forId id: Int, completion: @escaping (Loaded<[T]>) -> ()){
        let jsonData = getJsonData(path.rawValue)
        do {
            if jsonData != nil{
                let parsed = try JSONDecoder().decode([T].self, from: jsonData!)
                completion(.loaded(data: parsed))
            }
            else{
                completion(.error)
            }
        }catch let error{
            print(error)
            completion(.error)
        }
    }

    
    public func getJsonData(_ path: String) -> Data? {
        do {
            if let file = Bundle.main.url(forResource: path, withExtension: "json"){
                let data = try Data(contentsOf: file)
                return data
            }else{
                print("no file")
            }
            return nil
        }catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
