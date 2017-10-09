//
//  User.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 9/27/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import Foundation

class User: NSObject {
    static let userDidLogout = "UserLogout"

    var name: String?
    var screenName: String!
    var profileUrl: URL?
    var profileBannerUrl: URL?
    var tagline: String?
    var id: String?
    var dictionary: Dictionary<String, AnyObject>?
    var tweetCount: Int?
    var followingCount: Int?
    var followerCount: Int?
    
    init(dictionary: Dictionary<String, AnyObject>) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String

        if let bannerUrlString = dictionary["profile_banner_url"] as? String {
            profileBannerUrl = URL(string: bannerUrlString + "/mobile_retina")
        }

        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            // force the high res version
            let highResProfileUrlString = profileUrlString.replacingOccurrences(of: "_normal", with: "")
            profileUrl = URL(string: highResProfileUrlString)
        }

        tagline = dictionary["description"] as? String
        id =  dictionary["id_str"] as? String
        self.dictionary = dictionary
        
        tweetCount = dictionary["statuses_count"] as? Int
        followerCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
    }
    
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                
                if let data = defaults.object(forKey: "currentUser") as? Data {
                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, AnyObject>
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user  {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUser")
                defaults.synchronize()
                
                addUser(newUser: user)
            } else {
                defaults.removeObject(forKey: "currentUser")
            }
        }
    }
    
    static var users: [User] = []

    
    
    
    
    static func loadUsers() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.array(forKey: "users") else {
            print("No users")
            return
        }
        var usersData: [Data] = data as! [Data]
        
        for index in 0...(usersData.count-1) {
            let data: Data = usersData[index]
            let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, AnyObject>
            users.append(User(dictionary: dictionary))
        }
        print("Loaded \(users.count) users")
    }
    
    static func addUser(newUser: User) {
        // first check to see if we already have this use
        for index in 0..<users.count {
            let user = users[index]
            if newUser.screenName == user.screenName {
                print("Already have user \(user.screenName!)")
                return
            }
        }
        print("Adding user \(newUser.screenName!)")
        users.append(newUser)
        storeUsers()
    }
    
    static func removeUser(userToRemove: User) {
        for index in 0..<users.count {
            let user = users[index]
            if userToRemove.screenName == user.screenName {
                print("Removing \(user.screenName!)")
                users.remove(at: index)
                storeUsers()
                
                if currentUser?.screenName == userToRemove.screenName {
                    print("Removed current user")
                    if users.count > 0 {
                        let newUser = users[0]
                        TwitterClient.sharedInstance.switchCredential(to: newUser.screenName!, success: {
                            currentUser = newUser
                        }, failure: { (Error) in
                            
                        })
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserEvent.updateUser.rawValue), object: nil)
                return
            }
        }
        print("Could not find user \(userToRemove.screenName!)")
    }
    
    static func switchUserIfPossible() {
        if users.count > 0 {
            let newCurrentUser = users[0]
            print("New current user is \(newCurrentUser.screenName!)")
            currentUser = newCurrentUser
        }
    }
    
    static func storeUsers() {
        let userDefaults = UserDefaults.standard
        
        // serialize users
        var usersData: [Data] = []
        for index in 0..<users.count {
            let user = users[index]
            let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
            usersData.append(data)
        }
        userDefaults.set(usersData, forKey: "users")
        userDefaults.synchronize()
        print("Stored \(users.count) users")
    }
}
