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

    @IBOutlet weak var userTableView: UITableView!
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
        TwitterClient.sharedInstance.login(screenName: nil, success: {
            print("Logged in !!")
            self.launchMenu()
//            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }) { (error: Error) in
        }
    }
    
    func launchMenu () {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let hamburgerVC = storyBoard.instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController
//        
//        let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
//        
//        menuVC.hamburgerViewController = hamburgerVC
//        hamburgerVC.menuViewController = menuVC
//        
        self.present(hamburgerVC, animated: true, completion: nil)
    }
}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = User.users[indexPath.row].screenName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        tableView.deselectRow(at: didSelectRowAt, animated: false)
        
        let user = User.users[didSelectRowAt.row]
        TwitterClient.sharedInstance.switchCredential(to: user.screenName!, success: {
            self.launchMenu()
        }) { (Error) in
        
        }
    }
}
