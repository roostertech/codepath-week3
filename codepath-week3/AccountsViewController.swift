//
//  AccountsViewController.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 10/9/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController {

    @IBOutlet weak var accountTable: UITableView!
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: UserEvent.updateUser.rawValue), object: nil, queue: OperationQueue.main) { (Notification) in
            print("User updated, reloading")
            self.accountTable.reloadData()
            self.hamburgerViewController.toggleAccount()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension AccountsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.users.count + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        print("Seleced to \(didSelectRowAt)")
        tableView.deselectRow(at: didSelectRowAt, animated: false)
        
        if didSelectRowAt.row == User.users.count {
            TwitterClient.sharedInstance.login(screenName: nil, success: { 
                self.accountTable.reloadData()
            }, failure: { (Error) in
                
            })
            return
        }
        
        let user = User.users[didSelectRowAt.row]
        TwitterClient.sharedInstance.switchCredential(to: user.screenName!, success: {
            User.currentUser = user
            print("Switched to \(user.screenName!)")
            self.hamburgerViewController.toggleAccount()
        }) { (Error) in
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == User.users.count) {
            let cell = UITableViewCell()
            cell.textLabel?.text = "+ Add new account"
            return cell
        }
        let user = User.users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell") as! AccountCell
        cell.prepare(user: user)
        print("\(indexPath) -> \(user.screenName!)")
        return cell
    }
}


