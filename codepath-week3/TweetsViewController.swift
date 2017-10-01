//
//  TweetsViewController.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 9/29/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit
import MBProgressHUD
import PopupDialog

class TweetsViewController: UIViewController {
    
    @IBOutlet weak var tweetsView: UITableView!
    
    var tweets: [Tweet] = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tweetsView.insertSubview(refreshControl, at: 0)
        tweetsView.estimatedRowHeight = 140
        tweetsView.rowHeight = UITableViewAutomaticDimension
        edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        refreshData(refreshControl: nil, showProgress: true)
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData(refreshControl: UIRefreshControl?, showProgress : Bool) {
        
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            print("Have \(tweets.count) tweets")
            self.tweetsView.reloadData()
            refreshControl?.endRefreshing()
            
        }) { (error: Error) in
            refreshControl?.endRefreshing()
        }
    }
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        refreshData(refreshControl: refreshControl, showProgress: false)
    }
    
    func onNewTweet(_ newTweet: Tweet) {
        self.tweets.insert(newTweet, at: 0)
        self.tweetsView.reloadData()
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SingleTweetViewController {
            
            let detailController = segue.destination as! SingleTweetViewController
            guard let cell = sender as? TweetCell else {
                return
            }
            let indexPath = self.tweetsView.indexPath(for: cell)
            detailController.prepare(tweet: tweets[indexPath!.row], addTweetAction: { (newTweet: Tweet) in
                self.onNewTweet(newTweet)
            })
            
        } else if segue.destination is NewTweetViewController {
            let vc = segue.destination as! NewTweetViewController
            vc.prepare(tweetText: nil, replyTo: nil, addTweetAction: { (newTweet: Tweet) in
                self.onNewTweet(newTweet)
            })
        }
    }
    
    @IBAction func unwindToTweets(segue: UIStoryboardSegue) {
        print("Unwinding")
        tweetsView.reloadData()
    }
}

// MARK: - UITableView
extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.prepare(tweet: self.tweets[indexPath.row])
        return cell
    }
}
