//
//  NewTweetViewController.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 9/29/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {
    
    @IBOutlet fileprivate weak var textInput: UITextView!
    @IBOutlet fileprivate weak var characterCounter: UILabel!
    @IBOutlet fileprivate weak var tweetButton: UIButton!
    
    fileprivate var replyTo: String?
    fileprivate var initialText: String?
    fileprivate var addTweetAction: (Tweet) -> () = { (newTweet: Tweet) in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if initialText != nil {
            textInput.text = initialText
            textViewDidChange(textInput)
        }
        tweetButton.isEnabled = true
        textInput.becomeFirstResponder()
        textInput.layer.cornerRadius = 5
        textInput.layer.masksToBounds = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(_ sender: Any) {
        tweetButton.isEnabled = false
        
        TwitterClient.sharedInstance.updateStatus(newStatus: textInput.text, replyTo: replyTo) { (response: Any?, error: Error?) in
            if error == nil {
                print("Finished tweeting")
                let newTweet = Tweet(dictionary: response as! Dictionary<String, Any>)
                self.addTweetAction(newTweet)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.tweetButton.isEnabled = true
            }
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func prepare(tweetText: String?, replyTo: String?, addTweetAction: ((Tweet) -> ())?) {
        self.initialText = tweetText
        self.replyTo = replyTo
        
        if addTweetAction != nil {
            self.addTweetAction = addTweetAction!
        }
    }
}

extension NewTweetViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.characters.count
        characterCounter.text = String(140 - count)
        if count > 140 {
            tweetButton.isEnabled = false
        } else {
            tweetButton.isEnabled = true
        }
    }
}
