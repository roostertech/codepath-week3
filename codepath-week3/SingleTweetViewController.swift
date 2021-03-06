//
//  SingleTweetViewController.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 9/30/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit
import MBProgressHUD

class SingleTweetViewController: UIViewController {
    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userName: UILabel!
    @IBOutlet private weak var userScreenName: UILabel!
    @IBOutlet private weak var tweetDate: UILabel!
    @IBOutlet private weak var tweetMessage: UILabel!
    
    @IBOutlet private weak var retweetCount: UILabel!
    @IBOutlet private weak var likeCount: UILabel!
    
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var retweetButton: UIButton!
    @IBOutlet private weak var replyButton: UIButton!
    
    @IBOutlet private weak var tweetPic: UIImageView!
    
    @IBOutlet private weak var topRetweetStack: UIStackView!
    @IBOutlet private weak var topRetweetText: UILabel!
    
    private var tweet: Tweet!
    
    private func updateView() {
        if let user = tweet.originalUser {
            userName.text = user.name
            userScreenName.text = "@\(user.screenName!)"
            if let url = user.profileUrl {
                userImage.setImageWith(url)

            }
        }
        
        retweetCount.text = tweet.retweetCount?.description
        likeCount.text = tweet.favCount?.description
        tweetMessage.text = tweet.text
        tweetDate.text = tweet.prettyTweetTime
        
        if tweet.favorited {
            likeButton.imageView?.tintColor = .red
        } else {
            likeButton.imageView?.tintColor = .black
        }
        
        if tweet.retweeted {
            retweetButton.imageView?.tintColor = .green
        } else {
            retweetButton.imageView?.tintColor = .black
        }
        
        if tweet.isARetweet {
            topRetweetStack.isHidden = false
            topRetweetText.text = "Retweeted by \(tweet.user!.name!)"
        } else {
            topRetweetStack.isHidden = true
        }
        
        if let picUrl = tweet.photoUrl {
            tweetPic.setImageWith(URL(string: picUrl)!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likeButton.tintColor = .red
        
        userImage.layer.cornerRadius = 5
        userImage.layer.masksToBounds = true;
        
        userImage.isUserInteractionEnabled = true
        let imageTap = UITapGestureRecognizer()
        imageTap.numberOfTapsRequired = 1
        imageTap.addTarget(self, action: #selector(didTapProfileImage(_:)))
        
        userImage.addGestureRecognizer(imageTap)
        
        
        updateView()
    }
    
    func didTapProfileImage(_ gesture: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showProfile", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onReply(_ sender: Any) {
        self.performSegue(withIdentifier: "newTweetReply", sender: self)
   
    }

    @IBAction func onRetweet(_ sender: Any) {
        guard let tweetId = tweet.tweetId else {
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if tweet.retweeted {
            print("Un-Retweeting tweet \(tweetId)")
            TwitterClient.sharedInstance.unRetweet(tweetId: tweetId, completion: {(response: Any?, error: Error?) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == nil {
                    self.tweet.update(dictionary: response as! Dictionary<String, Any>)
                    
                    // work around api not updating properly
                    self.tweet.retweeted = false
                    if self.tweet.user?.id == self.tweet.originalUser?.id {
                        self.tweet.isARetweet = false
                    }
                    
                    self.updateView()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: TweetEvent.updateTweet.rawValue), object: nil)
                }
            })
        } else {
            print("Retweeting tweet \(tweetId)")
            TwitterClient.sharedInstance.retweet(tweetId: tweetId, completion: {(response: Any?, error: Error?) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == nil {
                    self.tweet.update(dictionary: response as! Dictionary<String, Any>)
                    self.updateView()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: TweetEvent.updateTweet.rawValue), object: nil)
                }
            })
        }
    }
    
    @IBAction func onLike(_ sender: Any) {
        guard let tweetId = tweet.tweetId else {
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if tweet.favorited {
            print("Un-Liking tweet \(tweetId)")
            TwitterClient.sharedInstance.favoriteDestroy(tweetId: tweetId, completion: { (response: Any?, error: Error?) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == nil {
                    self.tweet.update(dictionary: response as! Dictionary<String, Any>)
                    self.updateView()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: TweetEvent.updateTweet.rawValue), object: nil)

                }
            })
        } else {
            print("Liking tweet \(tweetId)")
            TwitterClient.sharedInstance.favoriteCreate(tweetId: tweetId, completion: { (response: Any?, error: Error?) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == nil {
                    self.tweet.update(dictionary: response as! Dictionary<String, Any>)
                    self.updateView()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: TweetEvent.updateTweet.rawValue), object: nil)
                }
            })
        }
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NewTweetViewController {
            
            let newTweetVC = segue.destination as! NewTweetViewController
            newTweetVC.prepare(tweetText: "@\(tweet.originalUser!.screenName!) ", replyTo: tweet.tweetId!)        } else if segue.destination is ProfileViewController {
            let profileVC = segue.destination as! ProfileViewController
            profileVC.prepare(tweet.originalUser!.screenName!)
//            profileVC.profileScreenName = tweet.originalUser?.screenName
        }
    }
    
    func prepare(tweet: Tweet) {
        self.tweet = tweet
    }
}
