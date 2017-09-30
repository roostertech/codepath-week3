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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
