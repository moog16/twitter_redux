//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Matthew Goo on 10/3/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

@objc protocol NewTweetViewControllerDelegate {
    optional func newTweetViewController(newTweetViewController: NewTweetViewController, didTweet tweet: Tweet)
}

class NewTweetViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var newTweetTextView: UITextView!
    
    var currentUser = User.currentUser!
    weak var delegate: NewTweetViewControllerDelegate?
    
    var isReplyTweet = false
    var tweetToReply: Tweet?
    var tweetCharCount: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let avatarUrl = NSURL(string: currentUser.profileImageUrl!)
        userNameLabel.text = currentUser.name
        userScreenNameLabel.text = "@\(currentUser.screenname!)"
        userAvatarImageView.setImageWithURL(avatarUrl!)
        newTweetTextView.delegate = self
        
        if isReplyTweet == true {
            if let tweet = tweetToReply {
                newTweetTextView.text = "@\(tweet.user!.screenname!)"
            }
        }
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        setupTweetBarButton()
    }
    
    func setupTweetBarButton() {
        let tweetButton = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Plain, target: nil, action: "sendTweet")
        tweetCharCount = UIBarButtonItem(title: "\(140 - newTweetTextView.text.characters.count)", style: UIBarButtonItemStyle.Plain, target: nil, action: "nil")
        tweetCharCount?.tintColor = UIColor.grayColor()
        
        navigationItem.rightBarButtonItems = [tweetButton, tweetCharCount!]
    }
    
    func textViewDidChange(textView: UITextView) {
        let charsRemaining = 140 - textView.text.characters.count
        if charsRemaining <= 0 {
            let text = textView.text
            textView.text = text.substringToIndex(text.endIndex.predecessor())
        }
        
        tweetCharCount?.title = "\(charsRemaining)"
    }
    
    func sendTweet() {
        guard newTweetTextView.text.characters.count <= 0 else {
            var params = ["status": newTweetTextView.text]
            if isReplyTweet == true {
                params["in_reply_to_status_id"] = "\(tweetToReply!.id!)"
            }
            TwitterClient.sharedInstance.tweetMessageWithParams(params) {
                (tweet: Tweet?, error: NSError?) -> Void in
                if error != nil {
                    print("error sending tweet \(error)")
                } else {
                    self.delegate?.newTweetViewController?(self, didTweet: tweet!)
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
            return
        }
    }
}

