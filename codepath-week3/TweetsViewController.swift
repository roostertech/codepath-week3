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
    
    @IBOutlet fileprivate weak var tweetsView: UITableView!
    
    fileprivate var tweets: [Tweet] = [Tweet]()
    fileprivate var isMoreDataLoading = false

    var timeline: TwitterClient.Timeline!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tweetsView.insertSubview(refreshControl, at: 0)
        tweetsView.estimatedRowHeight = 140
        tweetsView.rowHeight = UITableViewAutomaticDimension
        
        edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        tweetsView.tableFooterView = UIView()
        refreshData(refreshControl: nil, fetchMore: false)
    }
    
    @IBAction func onOpenMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MenuEvent.toggleDrawer.rawValue), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func refreshData(refreshControl: UIRefreshControl?, fetchMore : Bool) {
        var maxId: String?
        if self.tweets.count > 0 && fetchMore {
            let lastTweet = tweets[self.tweets.count - 1]
            maxId = lastTweet.tweetId
        }
        
  
        TwitterClient.sharedInstance.fetchTimeline(maxId: maxId, timeline: timeline) { (response: Any?, error: Error?) in
            self.isMoreDataLoading = false
            
            if error == nil {
                guard let tweets = response as? [Tweet] else {
                    return
                }
                if maxId == nil {
                    self.tweets = tweets
                } else {
                    self.tweets.append(contentsOf: tweets)
                }
                print("Have \(tweets.count) tweets")
                self.tweetsView.reloadData()
            }
        }
        
//        TwitterClient.sharedInstance.homeTimeline(maxId: maxId) { (response: Any?, error: Error?) in
//            refreshControl?.endRefreshing()
//            self.isMoreDataLoading = false
//
//            if error == nil {
//                guard let tweets = response as? [Tweet] else {
//                    return
//                }
//                if maxId == nil {
//                    self.tweets = tweets
//                } else {
//                    self.tweets.append(contentsOf: tweets)
//                }
//                print("Have \(tweets.count) tweets")
//                self.tweetsView.reloadData()
//            }
//        }
//        
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        refreshData(refreshControl: refreshControl, fetchMore: false)
    }
    
    private func onNewTweet(_ newTweet: Tweet?) {
        guard let newTweet = newTweet else {
            self.tweetsView.reloadData()
            return
        }
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
            detailController.prepare(tweet: tweets[indexPath!.row], addTweetAction: { (newTweet: Tweet?) in
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
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.prepare(tweet: self.tweets[indexPath.row])
        return cell
    }
    
    // get rid of selection gray
    internal func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        self.tweetsView.deselectRow(at: didSelectRowAt, animated: true)
    }
    
}

// MARK:- UIScrollViewDelegate
extension TweetsViewController: UIScrollViewDelegate {
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tweets.count < 20 {
            // We already have all the tweets
            return
        }
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tweetsView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tweetsView.bounds.size.height
            
//            print("Height \(scrollViewContentHeight) threshold \(scrollOffsetThreshold) \(tweetsView.contentSize.height) \(tweetsView.bounds.size.height)")
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tweetsView.isDragging) {
                isMoreDataLoading = true
                self.refreshData(refreshControl: nil, fetchMore: true)
            }
        }
    }
}
