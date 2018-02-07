//
//  TravelApi.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import PromiseKit

protocol APIService {
    func getPosts() -> Promise<PostsResponse>
    func getTrips() -> Promise<TripsResponse>
    func createDraft() -> Promise<DraftResponse>
    func updateDraft(draft: Draft) -> Promise<DraftResponse>
}

class TravelApi: APIService {
 
    func getPosts() -> Promise<PostsResponse> {
        return firstly {
            request(resource: [Post].self, path: ResourcePath.posts)
        }.then { posts in
            return Promise(value: PostsResponse(posts: posts))
        }
    }
    
    func getTrips() -> Promise<TripsResponse> {
        return firstly {
            request(resource: [Trip].self, path: ResourcePath.trips)
        }.then { trips in
            return Promise(value: TripsResponse(trips: trips))
        }
    }
    
    func createDraft() -> Promise<DraftResponse> {
        let post = Draft(id: 1, author: 1, content: [], title: "", trip: Trip(id: 0, title: "", posts: []), location: "")
        return Promise(value: DraftResponse(draft: post))
    }
    
    func updateDraft(draft: Draft) -> Promise<DraftResponse> {
        return Promise(value: DraftResponse(draft: draft))
    }
    
    
    private func request<T: Codable>(resource: T.Type, path: ResourcePath) -> Promise<T> {
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

enum APIError: Error {
    case apiError
}
