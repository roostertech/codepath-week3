//
//  ProfileCell.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 10/6/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var profileBanner: UIImageView!
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var tagline: UILabel!
    
    
    @IBOutlet weak var nameViewLeadingConstraint: NSLayoutConstraint!
    
    private var userProfile: User!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userProfileImage.layer.cornerRadius = 30
        userProfileImage.layer.borderWidth = 2
        userProfileImage.layer.borderColor = UIColor.white.cgColor
        userProfileImage.layer.masksToBounds = true;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func makeCompactNumber(_ number: Int) -> String {
        if number > 1000000 {
            return (number/1000000).description + "M"
        } else if number > 1000 {
            return (number/1000).description + "K"
        } else {
            return number.description
        }
    }
    
    func prepare(with user: User) {
        self.userProfile = user
        
        print("Profile \(user)")
 
        userName.text = userProfile.name
        userScreenName.text = "@" + userProfile.screenName!
        tagline.text = userProfile.tagline!
        tweetCount.text = makeCompactNumber(userProfile.tweetCount!)
        followingCount.text = makeCompactNumber(userProfile.followingCount!)
        followerCount.text = makeCompactNumber(userProfile.followerCount!)
        
        if let imageUrl = userProfile.profileUrl {
            userProfileImage.setImageWith(imageUrl)
        }
        
        if let bannerUrl = userProfile.profileBannerUrl {
            profileBanner.setImageWith(bannerUrl)
            originalTransform = profileBanner.transform
            originalBound = profileBanner.bounds
        }
    }
    
    var originalTransform: CGAffineTransform?
    var originalBound: CGRect?
    
    func scroll(_ yOffset: CGFloat) {

        
        if yOffset >= 0 {
            profileBanner.transform = originalTransform!
        }
        if yOffset < 0 {

            profileBanner.transform = CGAffineTransform.identity.scaledBy(x: 1 - yOffset/65, y: 1 - yOffset/65).translatedBy(x: 0, y: -yOffset)
//            (scaleX: 1 - yOffset/65, y: 1 - yOffset/65)
            


        } else if yOffset > 180 {
            profileBanner.layer.opacity = 0
        } else {
            profileBanner.layer.opacity = Float(180 - yOffset) / 180
        }
    }
    
    @IBAction func onPageChanged(_ sender: Any) {
        let pageControl = sender as! UIPageControl
        print(pageControl.currentPage)
        if pageControl.currentPage == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.nameViewLeadingConstraint.constant = 0
                self.contentView.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {

            self.nameViewLeadingConstraint.constant = self.contentView.frame.size.width
                self.contentView.layoutIfNeeded()
            })
        }
    }
    
}
