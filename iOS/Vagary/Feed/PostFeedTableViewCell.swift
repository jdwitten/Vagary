//
//  PostTableViewCell.swift
//  Travel
//
//  Created by Jonathan Witten on 7/16/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import UIKit

class PostFeedTableViewCell: UITableViewCell, RespondingWhenSelectedCell {

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
    
    var action: AnyCellAction?
    
}

class PostCellViewModel: CellViewModel {
    
    var reuseIdentifier: String = "PostFeedTableViewCell"
    
    var tripText: String
    var locationText: String
    var coverImage: String
    var title: String
    var postText: String
    var userImage: String
    var userHandle: String
    var timestamp: String
    var id: Int

    var action: FeedCellAction
    
    init(tripText: String,
         locationText: String,
         coverImage: String,
         title: String,
         postText: String,
         userImage: String,
         userHandle: String,
         timestamp: String,
         id: Int,
         action: FeedCellAction) {
        self.tripText = tripText
        self.locationText = locationText
        self.coverImage = coverImage
        self.title = title
        self.postText = postText
        self.userImage = userImage
        self.userHandle = userHandle
        self.timestamp = timestamp
        self.id = id
        self.action = action
    }
    
    convenience init(post: Post) {
        self.init(tripText: post.trip.title,
                  locationText: post.location,
                  coverImage: "IMG_4178 2" ,
                  title: post.title,
                  postText: "",
                  userImage: "JonathanWitten",
                  userHandle: String(describing: post.author),
                  timestamp: "",
                  id: post.id,
                  action: FeedCellAction.selectPost)
    }
    
    func configure(_ cell: PostFeedTableViewCell) {
        cell.tripLabel.text = tripText
        cell.locationLabel.text = locationText
        cell.coverImage.image = UIImage(named: coverImage)
        cell.title.text = title
        cell.postText.text = postText
        cell.userImage.image = UIImage(named: userImage)
        cell.timestampLabel.text = timestamp
        cell.action = action
    }
    
    
}
