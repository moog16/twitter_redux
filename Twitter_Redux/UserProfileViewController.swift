//
//  UserProfieViewController.swift
//  Twitter_Redux
//
//  Created by Matthew Goo on 10/11/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var descriptionLabel: UILabel = UILabel()
    var screennameLabel: UILabel = UILabel()
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
        
        refreshControlTableView = UIRefreshControl()
        refreshControlTableView!.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        userTableView.insertSubview(refreshControlTableView!, atIndex: 0)
        
        
        createPageControl()
        
        if let profileUser = profileUser {
            getUserTimeline(profileUser.screenname, completion: nil)
            getUserBanner(profileUser.screenname)
            setProfileStatuses(profileUser)
        }
    }
    
    @IBAction func didChangePage(sender: UIPageControl) {
        let xOffset = descriptionScrollView.bounds.width * CGFloat(pageControl.currentPage)
        descriptionScrollView.setContentOffset(CGPointMake(xOffset,0) , animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageControl.currentPage = Int(descriptionScrollView.contentOffset.x / descriptionScrollView.bounds.width)
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
    
    func createPageControl() {
        let descriptionView = UIView()
        descriptionView.addSubview(descriptionLabel)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        let screennameView = UIView()
        screennameView.addSubview(screennameLabel)
        screennameView.translatesAutoresizingMaskIntoConstraints = false
        screennameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont(name: "Helvetica-Bold", size: 17)
        descriptionLabel.textColor = UIColor.whiteColor()
        
        let pageWidth = descriptionScrollView.bounds.width
        let pageHeight = descriptionScrollView.bounds.height
        descriptionScrollView.pagingEnabled = true
        descriptionScrollView.contentSize = CGSizeMake(2*pageWidth, pageHeight)
        descriptionScrollView.showsHorizontalScrollIndicator = false
        descriptionScrollView.addSubview(screennameView)
        descriptionScrollView.addSubview(descriptionView)
        descriptionScrollView.delegate = self
        pageControl.numberOfPages = 2
        
        let views = [
            "descriptionView": descriptionView,
            "screennameView": screennameView,
            "descriptionLabel": descriptionLabel,
            "screennameLabel": screennameLabel,
            "scrollView": descriptionScrollView
        ]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[screennameLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[descriptionLabel]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[descriptionLabel(==scrollView)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[descriptionLabel(==scrollView)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[screennameView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[descriptionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[descriptionView(==scrollView)][screennameView(==scrollView)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
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
            usernameLabel.text = user.name
            screennameLabel.text = user.screenname!
            descriptionLabel.text = user.userDescription!

            followingCountLabel.text = "\(user.followingCount!)"
            followersCountLabel.text = "\(user.followersCount!)"
            tweetCountLabel.text = "\(user.tweetsCount!)"
        }
    }
}
