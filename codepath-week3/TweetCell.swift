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
    @IBOutlet private weak var heartImage: UIImageView!
    @IBOutlet private weak var retweetImage: UIImageView!
    
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

        // change to red if user favorited this tweet
        if tweet.favorited {
            heartImage.tintColor = .red
        } else {
            heartImage.tintColor = .black
        }
        
        if tweet.retweeted {
            retweetImage.tintColor = .green
        } else {
            retweetImage.tintColor = .black
        }

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
        likeCount.text = tweet.favCount?.description
        tweetMessage.text = tweet.text
        tweetTime.text = tweet.timestamp?.getElapsedInterval()
    }

}
