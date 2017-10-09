//
//  Event.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 10/5/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import Foundation

enum MenuEvent: String {
    case openDrawer = "openDrawer"
    case toggleDrawer = "toggleDrawer"
}

enum TweetEvent: String {
    case newTweet = "newTweet"
    case updateTweet = "updateTweet"
}
