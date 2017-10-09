//
//  HamburgerViewController.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 10/3/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit

@objc protocol ContainerViewGestureDelegate {
    @objc optional func onPanGesture(gesture: UIPanGestureRecognizer)
}

class HamburgerViewController: UIViewController {
    
    @IBOutlet private weak var accountView: UIView!
    @IBOutlet private weak var menuView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var leftMarginConstraint: NSLayoutConstraint!
    private var isMenuOpen = false
    private var isAccountOpen = false

    @IBOutlet weak var leftMenuConstraint: NSLayoutConstraint!

    private var gestureDelegate: ContainerViewGestureDelegate?
    
    var originaLeftMargin: CGFloat!
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    var accountViewController: AccountsViewController! {
        didSet {
            accountViewController.willMove(toParentViewController: self)
            accountView.addSubview(accountViewController.view)
            accountViewController.didMove(toParentViewController: self)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            closeMenu()
            
            if contentViewController is ContainerViewGestureDelegate {
                gestureDelegate = (contentViewController as! ContainerViewGestureDelegate)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        accountViewController = storyBoard.instantiateViewController(withIdentifier: "AccountsViewController") as! AccountsViewController
        
        accountViewController.hamburgerViewController = self

        let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.hamburgerViewController = self
        self.menuViewController = menuVC
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: MenuEvent.toggleDrawer.rawValue), object: nil, queue: OperationQueue.main) { (Notification) in
            if self.isMenuOpen {
                self.closeMenu()
            } else {
                self.openMenu()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        gestureDelegate?.onPanGesture?(gesture: sender)
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        print("t \(translation) v \(velocity)")
        
        if sender.state == .began {
            originaLeftMargin = leftMarginConstraint.constant
        } else if sender.state == .changed {
            // Don't swipe left
            if leftMarginConstraint.constant <= 0 && translation.x < 0 {
                return
            }
            
            leftMarginConstraint.constant = originaLeftMargin + translation.x
        } else if sender.state == .ended {
            
            if velocity.x > 0 {
                openMenu()
            } else {
                closeMenu()                                
            }
            
        }
    }
    
    func toggleAccount() {
        if isAccountOpen {
            UIView.animate(withDuration: 0.3, animations: {
                //            self.leftMenuConstraint.con
                self.leftMenuConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        } else {
            self.accountViewController.accountTable.reloadData()

            UIView.animate(withDuration: 0.3, animations: {
                //            self.leftMenuConstraint.con
                self.leftMenuConstraint.constant = self.view.frame.size.width - 100
                self.view.layoutIfNeeded()
            })
        }
        isAccountOpen = !isAccountOpen
    }
    
    private func openMenu() {
        isMenuOpen = true
        UIView.animate(withDuration: 0.3, animations: {
            self.leftMarginConstraint.constant = self.view.frame.size.width - 100
            self.view.layoutIfNeeded()
        })
    }
    
    private func closeMenu() {
        isMenuOpen = false

        UIView.animate(withDuration: 0.3, animations: {
            self.leftMarginConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
}
