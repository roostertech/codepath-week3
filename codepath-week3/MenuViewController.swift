//
//  MenuViewController.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 10/3/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    enum MenuItem: Int {
        case user = 0,
        home,
        profile,
        mentions
    }
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var homeIcon: UIImageView!
    @IBOutlet weak var profileIcon: UIImageView!
    
    var hamburgerViewController: HamburgerViewController!
    var homeNavController: UINavigationController!
    var mentionNavController: UINavigationController!
    var profileViewController: ProfileViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileImage.layer.cornerRadius = 40
        userProfileImage.layer.masksToBounds = true;

        homeIcon.image = #imageLiteral(resourceName: "home").withRenderingMode(.alwaysTemplate)
        homeIcon.tintColor = .white
        
        profileIcon.tintColor = .white
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
        
        homeNavController = storyBoard.instantiateViewController(withIdentifier: "TweetsNavController") as! UINavigationController
        
        let homeVc = homeNavController.viewControllers.first as! TweetsViewController
        homeVc.timeline = TwitterClient.Timeline.home
        
        mentionNavController = storyBoard.instantiateViewController(withIdentifier: "TweetsNavController") as! UINavigationController
        let mentionVc = mentionNavController.viewControllers.first as! TweetsViewController
        mentionVc.timeline = TwitterClient.Timeline.mention
        
        profileViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        hamburgerViewController.contentViewController = homeNavController
        
        if let user = TwitterClient.sharedInstance.getUserProfile() {
            renderUser(user: user)
        } else {
            TwitterClient.sharedInstance.fetchUserProfile(completion: { (user:User?, error: Error?) in
                if (error == nil) {
                    self.renderUser(user: user!)
                }
            })
        }
    }
    
    private func renderUser(user: User) {
        userProfileImage.setImageWith(user.profileUrl!)
        userName.text = user.name
        userScreenName.text = "@" + user.screenName!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case MenuItem.user.rawValue:
            hamburgerViewController.contentViewController = profileViewController
            return
        case MenuItem.home.rawValue:
            hamburgerViewController.contentViewController = homeNavController
            return
        case MenuItem.profile.rawValue:
            hamburgerViewController.contentViewController = profileViewController
            return
        case MenuItem.mentions.rawValue:
            hamburgerViewController.contentViewController = mentionNavController
            return
        default:
            return
        }
        
    }

}
