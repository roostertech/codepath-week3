//
//  AccountCell.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 10/9/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var panView: UIView!
    @IBOutlet weak var accountView: UIView!
    
    var originaLeftMargin: CGFloat!

    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var user: User!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userProfileImage.layer.cornerRadius = 5
        userProfileImage.layer.masksToBounds = true;
        
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(onPan(_:)))
        gesture.delegate = self
//        panView.addGestureRecognizer(gesture)
        accountView.addGestureRecognizer(gesture)
    }

    @IBAction func onPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: superview)
        let velocity = sender.velocity(in: superview)
        let point = sender.location(in: superview)

        print("Gesture at: \(point) \(velocity) \(translation)")
        
        if sender.state == .began {
            originaLeftMargin = leftMarginConstraint.constant
        } else if sender.state == .changed {
            // Don't swipe left
            if leftMarginConstraint.constant <= 0 && translation.x < 0 {
                return
            }
            
            leftMarginConstraint.constant = originaLeftMargin + translation.x
        } else if sender.state == .ended {
            leftMarginConstraint.constant = originaLeftMargin

            if translation.x > 150 {
                print("Removing \(user.screenName!)")
                User.removeUser(userToRemove: user)
            } else {
            }
            
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func prepare(user: User) {
        self.user = user
        
        userName.text = user.name
        userScreenName.text = user.screenName
        
        if let url = user.profileUrl {
            userProfileImage.setImageWith(url)
        }
    }
    
    public override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
