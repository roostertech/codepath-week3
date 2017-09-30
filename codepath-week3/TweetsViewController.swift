//
//  TweetsViewController.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 9/29/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    @IBOutlet weak var tweetsView: UITableView!
    
    var tweets: [Tweet] = [Tweet]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tweetsView.estimatedRowHeight = 140
        tweetsView.rowHeight = UITableViewAutomaticDimension
        
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            print("Have \(tweets.count) tweets")
            self.tweetsView.reloadData()
        }) { (error: Error) in
            
        }
    }

    @IBAction func onLogout(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPostTweet(_ sender: Any) {
        print("Posting a tweet")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
// MARK: - UITableView
extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.prepare(tweet: tweets[indexPath.row])
        return cell
    }
}
