//
//  Tweet.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 9/27/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    
    var text: String?
    var tweetId: String?
    var timestamp: Date?
    var prettyTweetTime: String?
    var retweetCount: Int?
    var favCount: Int?
    var user: User?
    var favorited: Bool = false
    var retweeted: Bool = false
    var photoUrl: String?

    var isARetweet: Bool = false
    var originalUser: User?
    
    convenience init(dictionary: Dictionary<String, Any>) {
        self.init()
        self.update(dictionary: dictionary)
    }
    
    func update(dictionary: Dictionary<String, Any>) {
        text = dictionary["text"] as? String
        tweetId = dictionary["id_str"] as? String
        favorited = (dictionary["favorited"] as? Bool)!
        retweeted = (dictionary["retweeted"] as? Bool)!
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        
        if let userData = dictionary["user"] as? Dictionary<String, AnyObject> {
            user = User(dictionary: userData)
        }
        
        // if there is a retweet status, that mean the outter user is the retweeter
        if let retweetStatus = dictionary["retweeted_status"] as? Dictionary<String, AnyObject> {
            originalUser = User(dictionary: retweetStatus["user"] as! Dictionary<String, AnyObject>)
            favCount = (retweetStatus["favorite_count"] as? Int) ?? 0

            isARetweet = true
        } else {
            originalUser = user
        }
        
        if let timestampStr = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampStr)
            
            let prettyTimeFormatter = DateFormatter()
            prettyTimeFormatter.locale = Locale(identifier: "en_US")
            prettyTimeFormatter.dateStyle = .medium
            prettyTimeFormatter.timeStyle = .medium
            prettyTweetTime = prettyTimeFormatter.string(from: timestamp!)
            
        }
        
        if let extendedEntities = dictionary["extended_entities"] as? Dictionary<String, AnyObject> {
            if let medias = extendedEntities["media"] as? [Dictionary<String, AnyObject>] {
                for media in medias {
                    if media["type"] as! String == "photo" {
                        photoUrl = media["media_url_https"] as? String
                        break
                    }
                }
            }
        }
    }
    
    class func tweetsWithArray(dictionaries: [Dictionary<String, Any>]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
