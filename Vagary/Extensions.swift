//
//  Extensions.swift
//  Vagary
//
//  Created by Jonathan Witten on 9/11/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    
    convenience init?(url: URL){
        self.init()
        let session = URLSession(configuration: .default)
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        // Do something with your image.
                        DispatchQueue.main.async { [unowned self] in
                            self.image = image
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
    }
    
}

public struct ImageWrapper: Codable {
    public let image: UIImage
    
    public enum CodingKeys: String, CodingKey {
        case image
    }
    
    public init(image: UIImage) {
        self.image = image
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: CodingKeys.image)
        guard let image = UIImage(data: data) else {
            throw CacheError.FetchingError
        }
        
        self.image = image
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        guard let data = UIImageJPEGRepresentation(image, 1.0) else {
            throw CacheError.InsertError
        }
        
        try container.encode(data, forKey: CodingKeys.image)
    }
}



