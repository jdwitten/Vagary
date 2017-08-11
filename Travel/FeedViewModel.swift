//
//  FeedViewModel.swift
//  Travel
//
//  Created by Jonathan Witten on 7/18/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa




struct FeedViewModel{
    
    
    let Posts: Driver<[Post]>
    let api = TravelApi()
    
    let refresh: Variable<Bool>
    
    
    init(){
        
        self.refresh = Variable<Bool>(false)
        
        
        let postResponseDriver: Driver<TravelAPIResponse> = refresh
            .asDriver()
            .map{ _ in PostSearchQuery(queryText: "", queryUser: 0, requestingUser: 0) }
            .flatMapLatest{
                return TravelApi.getPosts(withQuery: $0)
                    .asDriver(onErrorJustReturn: .Error)
            }
        
        self.Posts = postResponseDriver
            .debug()
            .map{
                switch $0{
                case .PostsResponse(let posts):
                    return posts
                default:
                    return []
                }
        }

    }
    
    
}


struct PostSearchQuery{
    
    let queryText: String
    let queryUser: Int
    let requestingUser: Int
}
