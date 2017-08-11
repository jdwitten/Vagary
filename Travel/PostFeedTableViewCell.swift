//
//  PostTableViewCell.swift
//  Travel
//
//  Created by Jonathan Witten on 7/16/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit

class PostFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var tripLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var coverImage: DesignableImage!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var viewPostLabel: UILabel!
    @IBOutlet weak var userImage: DesignableImage!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
