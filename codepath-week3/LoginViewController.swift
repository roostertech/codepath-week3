//
//  LoginViewController.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 9/26/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBOutlet private weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogin(_ sender: Any) {
        TwitterClient.sharedInstance.login(success: {
            print("Logged in !!")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }) { (error: Error) in
        }
    }
}
