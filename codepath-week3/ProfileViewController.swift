//
//  ProfileViewController.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 10/5/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userProfileBackground: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    
    var userProfile: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userProfileImage.layer.cornerRadius = 50
        userProfileImage.layer.masksToBounds = true;
        
        if let user = TwitterClient.sharedInstance.getUserProfile() {
            userProfile = user
            updateUI()
        } else {
            TwitterClient.sharedInstance.fetchUserProfile(completion: { (user: User?, error: Error?) in
                if error == nil {
                    self.userProfile = user!
                    self.updateUI()
                }
            })
        }
        
    }

    func updateUI() {
        userName.text = userProfile.name
        userScreenName.text = userProfile.screenName
        tweetCount.text = userProfile.tweetCount?.description
        followingCount.text = userProfile.followingCount?.description
        followerCount.text = userProfile.followerCount?.description
        
        userProfileImage.setImageWith(userProfile.profileUrl!)
        userProfileBackground.setImageWith(userProfile.profileBannerUrl!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigationtw
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
