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
    func createPost(draft: Draft) -> Promise<CreatePostResponse>
    func getPost(id: String) -> Promise<PostResponse>
    func getPostImageURL(fileType: String) -> Promise<PostImageURLResponse>
    func uploadImage(to url: String, data: Data) -> Promise<Void>
    func login(email: String, password: String) -> Promise<LoginResponse>
    func set(token: String)
}

protocol APINetwork {
    func request<T: Codable, R: Codable>(resource: T.Type, path: ResourcePath, requestParams: [String: String]?, requestBody: R, method: HTTPRequestType) -> Promise<T>
    func request<T: Codable>(resource: T.Type, path: ResourcePath, requestParams: [String: String]?, method: HTTPRequestType) -> Promise<T>
    func request(url: URL, requestBody: Data, method: HTTPRequestType, contentType: String) -> Promise<Void>
    func set(header: String, value: String)
}

public enum HTTPRequestType: String {
    case GET
    case POST
    case PUT
}

class TravelApi: APIService {
    
    let network: APINetwork

    init(network: APINetwork) {
        self.network = network
    }

    func getPosts() -> Promise<PostsResponse> {
        return self.network.request(resource: PostsResponse.self, path: ResourcePath.posts, requestParams: nil, method: .GET)
    }

    func getTrips() -> Promise<TripsResponse> {
        return firstly {
            self.network.request(resource: [Trip].self, path: ResourcePath.trips, requestParams: nil, method: .GET)
        }.then { trips in
            return Promise(value: TripsResponse(trips: trips))
        }
    }

    func createDraft() -> Promise<DraftResponse> {
        let post = Draft(id: 1, author: 1, content: [], title: "", trip: Trip(id: 0, title: "", posts: []), location: "", coverImage: DraftImage.url(""))
        return Promise(value: DraftResponse(draft: post))
    }

    func createPost(draft: Draft) -> Promise<CreatePostResponse> {
        return self.network.request(resource: CreatePostResponse.self, path: ResourcePath.posts, requestParams: nil, requestBody: CreatePostRequest(user: draft.author, body: draft.markdown ?? "", title: draft.title ?? "", location: draft.location ?? "", trip: draft.trip?.title ?? ""), method: .POST)
    }

    func getPost(id: String) -> Promise<PostResponse> {
        return self.network.request(resource: PostResponse.self, path: ResourcePath.post, requestParams: ["id": id], method: .GET)
    }
    
    func getPostImageURL(fileType: String) -> Promise<PostImageURLResponse> {
        return self.network.request(resource: PostImageURLResponse.self, path: ResourcePath.postImageRequest, requestParams: ["fileType": fileType], method: .GET)
    }
    
    func uploadImage(to url: String, data: Data) -> Promise<Void> {
        guard let url = URL(string: url) else {
            return Promise(error: APIError.invalidUrl)
        }
        return self.network.request(url: url, requestBody: data, method: .PUT, contentType: "image/jpeg")
    }
    
    func login(email: String, password: String) -> Promise<LoginResponse> {
        struct LoginRequest: Codable {
            var email: String
            var password: String
        }
        let body = LoginRequest(email: email, password: password)
        return self.network.request(resource: LoginResponse.self, path: ResourcePath.login, requestParams: nil, requestBody: body, method: .POST)
    }
    
    func set(token: String) {
        network.set(header: "x-access-token", value: token)
    }
}

enum APIError: Error {
    case apiError
    case invalidUrl
}
