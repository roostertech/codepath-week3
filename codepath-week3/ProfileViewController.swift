//
//  ProfileViewController.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 10/6/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    fileprivate var userProfile: User!
    fileprivate var tweeets: [Tweet] = []
    fileprivate var profileScreenName: String?

    fileprivate var profileCell: ProfileCell?
    
    @IBOutlet fileprivate weak var profileTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileTableView.estimatedRowHeight = 140
        profileTableView.rowHeight = UITableViewAutomaticDimension
        profileTableView.contentInset.top = topLayoutGuide.length - 65

        if profileScreenName == nil {
            // display own profile
            tweeets = TwitterClient.sharedInstance.getHomeTweets()

            if let user = TwitterClient.sharedInstance.getUserProfile() {
                userProfile = user
                profileTableView.reloadData()
                
                updateUser()
            } else {
                TwitterClient.sharedInstance.fetchUserProfile(completion: { (user: User?, error: Error?) in
                    if error == nil {
                        self.userProfile = user!
                        self.profileTableView.reloadData()
                        self.updateUser()
                    }
                })
            }

        } else {
            TwitterClient.sharedInstance.fetchUserProfile(userScreenName: profileScreenName!, completion: { (user: User?, error: Error?) in
                if error == nil {
                    self.userProfile = user!
                    self.profileTableView.reloadData()
                    self.updateUser()
                }
            })
        }
        
    }
    
    private func updateUser() {
        TwitterClient.sharedInstance.fetchUserTimeline(maxId: nil, screenName: userProfile.screenName, completion: { (response: Any?, error: Error?) in
            if error == nil {
                self.tweeets = response as! [Tweet]
                self.profileTableView.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepare(_ profileScreenName: String) {
        self.profileScreenName = profileScreenName
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SingleTweetViewController {
            
            let detailController = segue.destination as! SingleTweetViewController
            guard let cell = sender as? TweetCell else {
                return
            }
            let indexPath = self.profileTableView.indexPath(for: cell)
            detailController.prepare(tweet: tweeets[indexPath!.row])
        }
    }
}

// MARK:- UITableViewDataSource, UITableViewDelegate
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    enum Section: Int {
        case profile = 0
        case tweets
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // no data yet
        if userProfile == nil {
            return 0
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.profile.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
            cell.prepare(with: userProfile)
            self.profileCell = cell
            return cell
        case Section.tweets.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
            cell.prepare(tweet: tweeets[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.profile.rawValue:
            return 1
        case Section.tweets.rawValue:
            return tweeets.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case Section.tweets.rawValue:
            performSegue(withIdentifier: "showTweet", sender: tableView.cellForRow(at: indexPath))
            break;
        default:
            break
        }
    }
    
}



// MARK:- UIScrollViewDelegate
extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewContentHeight = profileTableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - profileTableView.bounds.size.height
        if scrollView.contentOffset.y < 181 {
            profileCell?.scroll(scrollView.contentOffset.y)
        }
        print("Height \(scrollViewContentHeight) threshold \(scrollOffsetThreshold) \(profileTableView.contentSize.height) \(profileTableView.bounds.size.height) \(scrollView.contentOffset.y)")
    }
}
