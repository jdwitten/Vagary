//
//  TravelApi.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation

class TravelApi{
    
    
    func getPost(forId id: Int, completion: @escaping (Loaded<Post>) -> ()){
        let json = parseJson("post")
        if let jsonPost = json["post"] as? [String: Any], let post = Post(json: jsonPost){
            completion(.loaded(data: post))
        }else{
            completion(.error)
        }
    }
    
    func getPosts(withQuery query: String, completion: @escaping (Loaded<[Post]>) -> ()){
        
        let json = parseJson("posts")
        var posts: [Post] = []
        if let jsonPosts = json["posts"] as? [[String: Any]] {
            for jsonPost in jsonPosts{
                if let post = Post(json: jsonPost){
                    posts.append(post)
                }
            }
        }
        completion(.loaded(data: posts))
    }
    
    func getPosts(forIds ids: [Int], completion: @escaping (Loaded<[Post]>) -> ()){
        
        let json = parseJson("posts")
        var posts: [Post] = []
        if let jsonPosts = json["posts"] as? [[String: Any]] {
            for jsonPost in jsonPosts{
                if let post = Post(json: jsonPost){
                    posts.append(post)
                }
            }
        }
        completion(.loaded(data: posts))
    }
    
    func getTrip(forId id: Int, completion: @escaping (Loaded<Trip>) -> ()){
        let json = parseJson("post")
        if let jsonPost = json["post"] as? [String: Any], let post = Trip(json: jsonPost){
            completion(.loaded(data: post))
        }else{
            completion(.error)
        }
    }
    
    func getTrips(for user: User, completion: @escaping (Loaded<[Trip]>)-> ()){
        
        let json = parseJson("trips")
        var trips: [Trip] = []
        if let jsonTrips = json["trips"] as? [[String: Any]] {
            for jsonTrip in jsonTrips{
                if let trip = Trip(json: jsonTrip){
                    trips.append(trip)
                }
            }
        }
        
        completion(.loaded(data: trips))
        
    }
    
    public func parseJson(_ path: String) -> [String: Any] {
        do {
            if let file = Bundle.main.url(forResource: path, withExtension: "json"){
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any]{
                    return object
                }else{
                    print("Invalid Json")
                }
            }else{
                print("no file")
            }
            return [:]
        }catch {
            print(error.localizedDescription)
            return [:]
        }
    }
}
