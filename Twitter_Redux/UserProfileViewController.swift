//
//  UserProfieViewController.swift
//  Twitter_Redux
//
//  Created by Matthew Goo on 10/11/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    var userStatuses: [NSDictionary] = []
    
    var tweets: [Tweet]?
    var bannerUrl: NSURL?
    var refreshControlTableView: UIRefreshControl?
    var profileUser: User! {
        didSet {
            if self.isViewLoaded() {
                getUserTimeline(profileUser.screenname, completion: nil)
                getUserBanner(profileUser.screenname)
                setProfileStatuses(profileUser)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTableView.delegate = self
        userTableView.dataSource = self
        let cellNib = UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle())
        userTableView.registerNib(cellNib, forCellReuseIdentifier: "TweetCell")
        
        userTableView.rowHeight = UITableViewAutomaticDimension
        userTableView.estimatedRowHeight = 150
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//        navigationController?.title = "\(User.currentUser?.screenname)"

        
        refreshControlTableView = UIRefreshControl()
        refreshControlTableView!.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        userTableView.insertSubview(refreshControlTableView!, atIndex: 0)
        
        
        getUserTimeline(profileUser.screenname, completion: nil)
        getUserBanner(profileUser.screenname)
        setProfileStatuses(profileUser)
    }
    
    func getUserTimeline(screenname: String?, completion:(()->())?) {
        if let screenname = screenname {
            let params = ["screen_name": screenname]
        
            TwitterClient.sharedInstance.userTimelineWithParams(params) { (tweets, error) -> () in
                self.tweets = tweets
                self.userTableView.reloadData()
                if completion != nil {
                    completion!()
                }
            }
        }
    }
    
    func onRefresh() {
        getUserTimeline(profileUser?.screenname) {
            refreshControlTableView?.endRefreshing()
        }
    }
    
    func getUserBanner(screenname: String?) {
        if let screenname = screenname {
            let params = ["screen_name": screenname]
        
            TwitterClient.sharedInstance.userProfileBannerWithParams(params) {(sizes, error) -> () in
                if error == nil {
                    if let sizes = sizes {
                        if let mobileRetinaSize = sizes["mobile_retina"] as? NSDictionary {
                            self.bannerUrl = NSURL(string: mobileRetinaSize["url"] as! String)
                            self.heroImageView.setImageWithURL(self.bannerUrl)
                        }
                    }
                } else {
                    print("error getting user banner \(error)")
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets?[indexPath.row]
//        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        userTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func setProfileStatuses(user: User?) {
        if let user = user {
            let avatarUrl = NSURL(string: user.profileImageUrl!)
            avatarImageView.setImageWithURL(avatarUrl!)

            followingCountLabel.text = "\(user.followingCount!)"
            followersCountLabel.text = "\(user.followersCount!)"
            tweetCountLabel.text = "\(user.tweetsCount!)"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
