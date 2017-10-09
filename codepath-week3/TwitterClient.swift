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
    
    enum Timeline: String {
        case home = "home"
        case mention = "mentions"
        case user = "user"

    }
    
    private var loginSuccess: (()->())?
    private var loginFailure: ((Error) -> ())?

    private var userProfile: User?
    private var homeTweets: [Tweet] = []
    
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
    
    func authenticate(screenName: String, success: @escaping  ()->(), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        print("Authenticating \(screenName)")
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"cptwit://oauth"), scope: nil, success: { (requestToken:
            BDBOAuth1Credential!)-> Void in
            print("Got token \(requestToken.token)")
            
            let url = URL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=\(requestToken.token!)&screen_name=\(screenName)")
            UIApplication.shared.open(url!, options: [String: Any](), completionHandler: nil)
        },failure: {(error: Error!) -> Void in
            print("Error \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func logout() {
        deauthorize()
        User.currentUser = nil
        
        // if user is last user, go back to login screen
        if User.currentUser == nil {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogout), object: nil)
        }
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
            let data = try! JSONSerialization.data(withJSONObject: token, options: [])
            print("access token \(data)")

            success()
        }, failure: { (error: Error!) -> Void in
            print("Error \(error.localizedDescription)")
            failure(error)
        })
    }

    
    //MARK:- Timelines
    func getHomeTweets() -> [Tweet] {
        return homeTweets
    }

    func fetchHomeTimeline(maxId: String?, completion: @escaping (Any?, Error?) -> ()) {
        var params: [String: String] = [String: String]()
        if maxId != nil {
            params["max_id"] = maxId
        }
        fetchTimeline(params: params, timeline: .home) { (response: Any?, error: Error?) in
            if error == nil {
                self.homeTweets = response as! [Tweet]
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }

    func fetchMentionTimeline(maxId: String?, completion: @escaping (Any?, Error?) -> ()) {
        var params: [String: String] = [String: String]()
        if maxId != nil {
            params["max_id"] = maxId
        }
        fetchTimeline(params: params, timeline: .mention, completion:  completion)
    }
    
    func fetchUserTimeline(maxId: String?, screenName: String?, completion: @escaping (Any?, Error?) -> ()) {
        var params: [String: String] = [String: String]()
        if maxId != nil {
            params["max_id"] = maxId
        }
        
        if screenName != nil {
            params["screen_name"] = screenName
        }
        fetchTimeline(params: params, timeline: .user, completion:  completion)
    }
    


    func fetchTimeline(maxId: String?, timeline: Timeline, completion: @escaping (Any?, Error?) -> ()) {
        var params: [String: String] = [String: String]()
        if maxId != nil {
            params["max_id"] = maxId
        }
        fetchTimeline(params: params, timeline: timeline, completion: completion)
    }
    
    func fetchTimeline(params: [String: String], timeline: Timeline, completion: @escaping (Any?, Error?) -> ()) {
        let endpoint = "1.1/statuses/" + timeline.rawValue + "_timeline.json"
        self.get(params: params, endpoint: endpoint) { (response: Any?, error: Error?) in
            if error == nil {
                let dictionaries = response as! [Dictionary<String, Any>]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                switch timeline {
                case .home:
                    if params["max_id"] != nil {
                        self.homeTweets.append(contentsOf: tweets)
                    } else {
                        self.homeTweets = tweets
                    }
                default:
                    break
                }
                completion(tweets, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func getTimeline(timeline: Timeline) -> [Tweet] {
        switch timeline {
        case .home:
            return homeTweets
        default:
            // not caching other type yet
            return []
        }
    }
    
    //MAKR:- Profile
    func getUserProfile() -> User? {
        return userProfile
    }
    
    func fetchUserProfile(userScreenName: String, completion: @escaping (User?, Error?) -> ()) {
        self.get(params: [:], endpoint: "1.1/users/show.json?screen_name=" + userScreenName) { (response: Any?, error: Error?) in
            if error == nil {
                let user = User(dictionary: response as! Dictionary)
                completion(user, error)
            } else {
                completion(nil, error)
            }
        }
    }

    func fetchUserProfile(completion: @escaping (User?, Error?) -> ()) {
        print("Fetching user profile")
        
        self.get(params: [:], endpoint: "1.1/account/verify_credentials.json") { (response: Any?, error: Error?) in
            if error == nil {
                let user = User(dictionary: response as! Dictionary)
                self.userProfile = response as? User
                completion(user, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let user = User(dictionary: response as! Dictionary)
            self.userProfile = user
            print("Name \(user.name!)")
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error \(error.localizedDescription)")
            failure(error)
        })
    }

    //MAKR:- Tweet
    func updateStatus(newStatus: String!, replyTo: String?, completion: @escaping (Tweet?, Error?) -> ()) {
        var params = ["status": newStatus]
        if let replyTo = replyTo {
            params["in_reply_to_status_id"] = replyTo
        }

        print("Sending tweet \(newStatus.characters.count)")
        self.post(params: params, endpoint: "1.1/statuses/update.json") { (response: Any?, error: Error?) in
            if error == nil {
                let newTweet = Tweet(dictionary: response as! Dictionary<String, Any>)
                self.homeTweets.insert(newTweet, at: 0)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: TweetEvent.newTweet.rawValue), object: nil)

                completion(newTweet, error)
            }
        }
    }

    //MARK:- Favorite
    func favoriteCreate(tweetId: String!, completion: @escaping (Any?, Error?) -> ()) {
        let params = ["id": tweetId]
        
        print("Favoriting tweet \(tweetId)")
        self.post(params: params, endpoint: "1.1/favorites/create.json", completion: completion)
    }
    
    func favoriteDestroy(tweetId: String!, completion: @escaping (Any?, Error?) -> ()) {
        let params = ["id": tweetId]
        
        print("Un-Favoriting tweet \(tweetId)")
        self.post(params: params, endpoint: "1.1/favorites/destroy.json", completion: completion)
    }
    
    //MARK:- Retweet
    func retweet(tweetId: String, completion: @escaping (Any?, Error?) -> ()) {
        let params = ["id": tweetId]
        
        print("Retweeting \(tweetId)")
        self.post(params: params, endpoint: "1.1/statuses/retweet/\(tweetId).json", completion: completion)
    }
    
    func unRetweet(tweetId: String, completion: @escaping (Any?, Error?) -> ()) {
        let params = ["id": tweetId]
        
        print("Un-Retweeting \(tweetId)")
        self.post(params: params, endpoint: "1.1/statuses/unretweet/\(tweetId).json", completion: completion)
    }
    
    //MARK:- Generics
    func post(params: [String : String?], endpoint: String, completion: @escaping (Any?, Error?) -> ()) {
        print("Invoking POST \(endpoint) params \(params)")
        post(endpoint, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print(response ?? "No response?")
            completion(response, nil)
            
            // yep being super lazy here, TODO
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: TweetEvent.updateTweet.rawValue), object: nil)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error \(error.localizedDescription)")
            completion(nil, error)
        })
    }
    
    func get(params: [String : String?], endpoint: String, completion: @escaping (Any?, Error?) -> ()) {
        print("Invoking GET \(endpoint) params \(params)")
        get(endpoint, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print(response ?? "No response?")
            completion(response, nil)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("Error \(error.localizedDescription)")
            completion(nil, error)
        })
    }
}
