//
//  Credentials.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 10/8/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

class Credentials: NSObject, NSCoding {
    static var instance: Credentials = loadCreds()
    
    private var credentials: [String: BDBOAuth1Credential] = [:]
    
    static func loadCreds() -> Credentials {
        let defaults = UserDefaults.standard
        let storedCreds = defaults.object(forKey: "credentials") as? Data
        
        if let storedCreds = storedCreds {
            if let credentials = (NSKeyedUnarchiver.unarchiveObject(with: storedCreds as Data) as? Credentials) {
                print("\(credentials.credentials.count)")
                return credentials
            }
        }
        print("No stored creds")
        // no stored data
        return Credentials()
    }

    static func storeCreds() {
        let credToStore = NSKeyedArchiver.archivedData(withRootObject: instance)
        let defaults = UserDefaults.standard
        defaults.set(credToStore, forKey: "credentials")

    }
    
    func addCreds(for screenName: String, token: BDBOAuth1Credential) {
        credentials[screenName] = token
        print("Added token for \(screenName) total \(credentials.count)")
        Credentials.storeCreds()
    }
    
    func getToken(for screenName: String) -> BDBOAuth1Credential? {
        return credentials[screenName]
    }

    func removeToken(for screenName: String) {
        if credentials.removeValue(forKey: screenName) != nil {
            Credentials.storeCreds()
        }
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.credentials, forKey: "tokens")
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()

        let credentials = aDecoder.decodeObject(forKey: "tokens") as! [String: BDBOAuth1Credential]
        self.credentials = credentials
    }
}
