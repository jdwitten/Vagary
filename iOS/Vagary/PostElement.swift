//
//  PostElement.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/30/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
enum PostElement: Codable{
    case image(DraftImage)
    case text(String)
}

extension PostElement {
    enum CodingKeys: String, CodingKey {
        case image
        case text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let image = try container.decodeIfPresent(DraftImage.self, forKey: .image) {
            self = .image(image)
            return
        }
        if let text = try container.decodeIfPresent(String.self, forKey: .text){
            self = .text(text)
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
        }
    }
}
