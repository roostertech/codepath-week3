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
    var timestamp: Date?
    var retweetCount: Int?
    var favCount: Int?
    var user: User?
    
    init(dictionary: Dictionary<String, Any>) {
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favCount = (dictionary["favourites_count"] as? Int) ?? 0

        
        if let timestampStr = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampStr)
        }
        
        if let userData = dictionary["user"] as? Dictionary<String, AnyObject> {
            user = User(dictionary: userData)
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
