//
//  TweetViewController.swift
//  Twitter
//
//  Created by Matthew Goo on 10/3/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UserActionsCellDelegate {
    
    var tweet: Tweet?
    
    @IBOutlet weak var tweetTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        tweetTableView.estimatedRowHeight = 150
        tweetTableView.reloadData()
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tweetTableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
            cell.isSingleTweetView = true
            cell.tweet = tweet
            return cell
        case 1:
            let cell = tweetTableView.dequeueReusableCellWithIdentifier("TweetStatusCell", forIndexPath: indexPath) as! TweetStatusCell
            cell.tweet = tweet
            return cell
        default:
            let cell = tweetTableView.dequeueReusableCellWithIdentifier("UserActionsCell", forIndexPath: indexPath) as! UserActionsCell
            cell.tweet = tweet
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func updateUserStatusesAndActions(tweet: Tweet, userActionsCell: UserActionsCell) {
        userActionsCell.tweet = tweet
        let statusCell = self.tweetTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as? TweetStatusCell
        statusCell!.tweet = tweet
    }
    
    func userActionsCellDelegate(userActionsCell: UserActionsCell, didTapRetweet tweet: Tweet) {
        if tweet.retweeted == false {
            TwitterClient.sharedInstance.retweetMessageWithParams(nil, tweetId: tweet.id!) { (tweet, error) -> () in
                if error != nil {
                    print("error from retweeting \(error)")
                } else {
                    self.updateUserStatusesAndActions(tweet!, userActionsCell: userActionsCell)
                }
            }
        }
    }
    
    func userActionsCellDelegate(userActionsCell: UserActionsCell, didTapFavorite tweet: Tweet) {
        if tweet.favorited == false {
            let parameters = ["id": tweet.id!]
            TwitterClient.sharedInstance.favoriteMessageWithParams(parameters) { (tweet, error) -> () in
                if error != nil {
                    print("error from favoriting \(error)")
                } else {
                    self.updateUserStatusesAndActions(tweet!, userActionsCell: userActionsCell)
                }
            }
        }
    }
    
    func userActionsCellDelegate(userActionsCell: UserActionsCell, didTapReply tweet: Tweet) {
        self.performSegueWithIdentifier("replyTweetSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! NewTweetViewController
        vc.tweetToReply = tweet
        vc.isReplyTweet = true
    }
}
