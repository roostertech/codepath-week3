//
//  TweetCell.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 9/29/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userName: UILabel!
    @IBOutlet private weak var userScreenName: UILabel!
    @IBOutlet private weak var tweetTime: UILabel!
    @IBOutlet private weak var tweetMessage: UILabel!
    
    @IBOutlet private weak var replyCount: UILabel!
    @IBOutlet private weak var retweetCount: UILabel!
    @IBOutlet private weak var likeCount: UILabel!
    
    private var tweet: Tweet!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(tweet: Tweet!) {
        self.tweet = tweet
        
        if let user = tweet.user {
            userName.text = user.name
            userScreenName.text = "@\(user.screenName!)"
            if let url = user.profileUrl {
                userImage.setImageWith(url)
                userImage.layer.cornerRadius = 5
                userImage.layer.masksToBounds = true;
            }
        }

        retweetCount.text = tweet.retweetCount?.description
        tweetMessage.text = tweet.text
        tweetTime.text = tweet.timestamp?.getElapsedInterval()
    }

}
