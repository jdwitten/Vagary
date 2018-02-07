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

protocol APINetwork {
    func request<T: Codable>(resource: T.Type, path: ResourcePath) -> Promise<T> 
}

class TravelApi: APIService {
    
    let network: APINetwork
    
    init(network: APINetwork) {
        self.network = network
    }
 
    func getPosts() -> Promise<PostsResponse> {
        return self.network.request(resource: PostsResponse.self, path: ResourcePath.posts)
    }
    
    func getTrips() -> Promise<TripsResponse> {
        return firstly {
            self.network.request(resource: [Trip].self, path: ResourcePath.trips)
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
}

enum APIError: Error {
    case apiError
}
