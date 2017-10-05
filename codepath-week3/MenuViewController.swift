//
//  MenuViewController.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 10/3/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    var hamburgerViewController: HamburgerViewController!
    var homeViewController: TweetsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
        
        homeViewController = storyBoard.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController

        hamburgerViewController.contentViewController = homeViewController
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
