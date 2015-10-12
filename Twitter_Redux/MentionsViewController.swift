//
//  MentionsViewController.swift
//  Twitter_Redux
//
//  Created by Matthew Goo on 10/11/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mentionsTableView: UITableView!
    
    var tweets: [Tweet]?
    override func viewDidLoad() {
        super.viewDidLoad()
        mentionsTableView.delegate = self
        mentionsTableView.dataSource = self
        let cellNib = UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle())
        mentionsTableView.registerNib(cellNib, forCellReuseIdentifier: "TweetCell")
        mentionsTableView.rowHeight = UITableViewAutomaticDimension
        mentionsTableView.estimatedRowHeight = 150
        self.title = "Mentions"

        TwitterClient.sharedInstance.userMentionsWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.mentionsTableView.reloadData()
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = mentionsTableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets?[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mentionsTableView.deselectRowAtIndexPath(indexPath, animated: true)
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
