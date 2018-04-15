//
//  NSAttributedString.swift
//  Vagary
//
//  Created by Jonathan Witten on 3/31/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    var draftElements: [DraftElement] {
        var elements: [DraftElement] = []
        self.enumerateAttributes(in: NSMakeRange(0, self.length), options: .longestEffectiveRangeNotRequired) { object, range, stop in
            if object.keys.contains(NSAttributedStringKey.attachment) {
                if let attachment = object[NSAttributedStringKey.attachment] as? NSTextAttachment {
                    if let image = attachment.image {
                        elements.append(.image(DraftImage(image: image)))
                    }
                }
            }else {
                let stringValue : String = self.attributedSubstring(from: range).string
                elements.append(.text(stringValue))
            }
            
        }
        return elements
    }
}
