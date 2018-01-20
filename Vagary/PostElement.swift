//
//  PostElement.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/30/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
enum PostElement: Codable{
    case image(ImageWrapper)
    case text(String)
    case url(String)
}

extension PostElement {
    enum CodingKeys: String, CodingKey {
        case image
        case text
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let image = try container.decodeIfPresent(ImageWrapper.self, forKey: .image) {
            self = .image(image)
            return
        }
        if let text = try container.decodeIfPresent(String.self, forKey: .text){
            self = .text(text)
            return
        }
        if let url = try container.decodeIfPresent(String.self, forKey: .url){
            self = .url(url)
            return
        }
        throw CacheError.FetchingError
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .image(let image):
            try container.encode(image, forKey: .image)
        case .text(let text):
            try container.encode(text, forKey: .text)
        case .url(let url):
            try container.encode(url, forKey: .url)
        }
    }
}
