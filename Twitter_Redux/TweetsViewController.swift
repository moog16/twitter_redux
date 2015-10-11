//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Matthew Goo on 10/1/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewTweetViewControllerDelegate, TweetCellDelegate {
    
    var tweets: [Tweet]?
    var refreshControlTableView: UIRefreshControl!
    @IBOutlet weak var tweetsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        let cellNib = UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle())
        tweetsTableView.registerNib(cellNib, forCellReuseIdentifier: "TweetCell")

        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 150
        
        refreshControlTableView = UIRefreshControl()
        refreshControlTableView.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tweetsTableView.insertSubview(refreshControlTableView, atIndex: 0)
        
        getHomeTimeline(nil)
    }
    
//    @IBAction func onSignOut(sender: UIBarButtonItem) {
//        User.currentUser?.logout()
//    }
    
    func getHomeTimeline(completion:(()->())?) {
        TwitterClient.sharedInstance.rateLimitWithParams()
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            if completion != nil {
                completion!()
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tweetsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        return 0
    }
    
    func onRefresh() {
        getHomeTimeline() {
            self.refreshControlTableView.endRefreshing()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tweetsTableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets?[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func newTweetViewController(newTweetViewController: NewTweetViewController, didTweet tweet: Tweet) {
        tweets?.insert(tweet, atIndex: 0)
        self.tweetsTableView.reloadData()
    }
    
    func tweetCellDelegate(tweetCell: TweetCell, didTapRetweet tweet: Tweet) {
        if tweet.retweeted == false {
            TwitterClient.sharedInstance.retweetMessageWithParams(nil, tweetId: tweet.id!) { (tweet, error) -> () in
                if error != nil {
                    print("error from retweeting \(error)")
                } else {
                    tweetCell.setRetweet(tweet!)
                }
            }
        }
    }
    
    func tweetCellDelegate(tweetCell: TweetCell, didTapFavorite tweet: Tweet) {
        if tweet.favorited == false {
            let parameters = ["id": tweet.id!]
            TwitterClient.sharedInstance.favoriteMessageWithParams(parameters) { (tweet, error) -> () in
                if error != nil {
                    print("error from favoriting \(error)")
                } else {
                    print("favorite count \(tweet?.favoriteCount)")
                    tweetCell.tweet = tweet
                }
            }
        }
    }
    
    func tweetCellDelegate(tweetCell: TweetCell, didTapReply tweet: Tweet) {
        self.performSegueWithIdentifier("newTweetSegue", sender: tweetCell)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender is TweetCell {
            let vc = segue.destinationViewController
            let cell = sender as! TweetCell
            if vc is TweetViewController {
                let tweetViewController = vc as! TweetViewController
                tweetViewController.tweet =  cell.tweet
            } else {
                let newTweetViewController = vc as! NewTweetViewController
                newTweetViewController.tweetToReply = cell.tweet
                newTweetViewController.isReplyTweet = true
                newTweetViewController.delegate = self
            }
        } else {
            let newTweetController = segue.destinationViewController as! NewTweetViewController
            newTweetController.delegate = self
        }
    }
    
}
