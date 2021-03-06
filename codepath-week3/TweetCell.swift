//
//  TweetCell.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 9/29/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit
import AFNetworking
import TTTAttributedLabel

class TweetCell: UITableViewCell {

    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userName: UILabel!
    @IBOutlet private weak var userScreenName: UILabel!
    @IBOutlet private weak var tweetTime: UILabel!
    @IBOutlet private weak var tweetMessage: TTTAttributedLabel!
    
    @IBOutlet private weak var replyCount: UILabel!
    @IBOutlet private weak var retweetCount: UILabel!
    @IBOutlet private weak var likeCount: UILabel!
    @IBOutlet private weak var heartImage: UIImageView!
    @IBOutlet private weak var retweetImage: UIImageView!
    
    @IBOutlet private weak var topRetweetImage: UIImageView!
    @IBOutlet private weak var topRetweetText: UILabel!
    @IBOutlet private weak var topRetweetContainer: UIView!
    
    @IBOutlet private weak var topRetweetContainerHeight: NSLayoutConstraint!
    @IBOutlet private weak var topRetweetStack: UIStackView!
    
    private var tweet: Tweet!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tweetMessage.enabledTextCheckingTypes = NSTextCheckingAllTypes
        tweetMessage.delegate = self
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

        if let user = tweet.originalUser {
            userName.text = user.name
            userScreenName.text = "@\(user.screenName!)"
            if let url = user.profileUrl {
                userImage.setImageWith(url)
                userImage.layer.cornerRadius = 5
                userImage.layer.masksToBounds = true;
            }
        }
        
        if tweet.isARetweet {
            topRetweetContainerHeight.constant = 20
            topRetweetContainerHeight.isActive = true
            topRetweetImage.isHidden = false
            topRetweetText.isHidden = false
            
            topRetweetText.text = "Retweeted by \(tweet.user!.name!)"
        } else {
            topRetweetStack.isHidden = true
            topRetweetImage.isHidden = true
            topRetweetText.isHidden = true
            
            topRetweetContainerHeight.constant = 0

        }

        retweetCount.text = tweet.retweetCount?.description
        likeCount.text = tweet.favCount?.description
        tweetMessage.text = tweet.text
        tweetTime.text = tweet.timestamp?.getElapsedInterval()
    }

}

// MARK:- TTTAttributedLabelDelegate
extension TweetCell: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithPhoneNumber phoneNumber: String!) {
        if let url = URL(string: "tel://\(phoneNumber!)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
