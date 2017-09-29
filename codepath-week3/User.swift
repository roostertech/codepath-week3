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
    var screenName: String?
    var profileUrl: URL?
    var tagline: String?
    
    var dictionary: Dictionary<String, AnyObject>?
    
    init(dictionary: Dictionary<String, AnyObject>) {
        name = dictionary["name"] as? String
        screenName = dictionary["screenName"] as? String

        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = URL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String
        self.dictionary = dictionary
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
            } else {
                defaults.removeObject(forKey: "currentUser")
            }
        }
    }
    
}
