//
//  HamburgerViewController.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 10/3/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    
    @IBOutlet private weak var menuView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originaLeftMargin: CGFloat!
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        print("t \(translation) v \(velocity)")
        
        if sender.state == .began {
            originaLeftMargin = leftMarginConstraint.constant
        } else if sender.state == .changed {
            leftMarginConstraint.constant = originaLeftMargin + translation.x
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.3, animations: {
                if velocity.x > 0 {
                    // open
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 100
                } else {
                    // close
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            }
            )
        }
        
    }
    
    private func closeMenu() {
        UIView.animate(withDuration: 0.3, animations: {
            self.leftMarginConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
}