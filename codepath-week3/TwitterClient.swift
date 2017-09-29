//
//  TwitterClient.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 9/27/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!,
                                              consumerKey: "U6hBZlE8BonmhRL5tOlJ3SJ8C",
                                              consumerSecret: "hxbfMA4E0RZuIbtprSyZqViFjCOurnx06OUGGCCxyBDBxdQhwm")!
    
    var loginSuccess: (()->())?
    var loginFailure: ((Error) -> ())?

    func login(success: @escaping  ()->(), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"cptwit://oauth"), scope: nil, success: { (requestToken:
            BDBOAuth1Credential!)-> Void in
            print("Got token \(requestToken.token)")
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")
            UIApplication.shared.open(url!, options: [String: Any](), completionHandler: nil)
        },failure: {(error: Error!) -> Void in
            print("Error \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func logout() {
        deauthorize()
        User.currentUser = nil
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogout), object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        getAccessToken(queryString: url.query, success: {
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
        }) { (error: Error) in
            self.loginFailure?(error)
        }
    }
    
    func getAccessToken(queryString: String!, success: @escaping  ()->(), failure: @escaping (Error) -> ()) {
        let requestToken = BDBOAuth1Credential(queryString: queryString)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (token: BDBOAuth1Credential!) -> Void in
            print("access token \(token.token)")
            success()
        }, failure: { (error: Error!) -> Void in
            print("Error \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [Dictionary<String, Any>]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
//            for tweet in tweets {
//                print("text \(tweet.text!)")
//            }
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let user = User(dictionary: response as! Dictionary)
            print("Name \(user.name!)")
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error \(error.localizedDescription)")
            failure(error)
        })
    }
}
