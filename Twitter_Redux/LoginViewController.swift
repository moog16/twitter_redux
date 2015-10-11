//
//  ViewController.swift
//  Twitter
//
//  Created by Matthew Goo on 10/1/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "onSignIn:")
        signInImageView.userInteractionEnabled = true
        signInImageView.addGestureRecognizer(tapRecognizer)
    }
    
    func onSignIn(tapGestureRecognizer: UITapGestureRecognizer) {
        TwitterClient.sharedInstance.loginWithCompletion {
            (user: User?, error: NSError?) in
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            } else {
                // handle login error
            }
        }
    }
}

