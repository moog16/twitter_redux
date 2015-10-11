//
//  Tweet.swift
//  Twitter
//
//  Created by Matthew Goo on 10/1/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var timeSince: String?
    var retweeted: Bool?
    var favorited: Bool?
    var userRetweet: User?
    var retweetCount: Int?
    var favoriteCount: Int?
    var id: Int?
    
    init(dictionary: NSDictionary) {
        super.init()
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        createdAtString = dictionary["created_at"] as? String
        text = dictionary["text"] as? String
        favoriteCount = dictionary["favorite_count"] as? Int
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        retweetCount = dictionary["retweet_count"] as? Int
        favoriteCount = dictionary["favorite_count"] as? Int
        id = dictionary["id"] as? Int
        
        if let userRetweet = dictionary["current_user_retweet"] {
            self.userRetweet = userRetweet as? User
            print(self.userRetweet!.name)
        }
        
        if let createdAtStr = createdAtString {
            createdAt = getDateFromString(createdAtStr)
        }
        
        if let createdAtDate = createdAt {
            timeSince = formatTimeElapsed(createdAtDate)
        }
    }
    
    func getDateFromString(string: String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        return formatter.dateFromString(string)!
    }
    
    func formatTimeElapsed(sinceDate: NSDate) -> String {
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Abbreviated
        formatter.collapsesLargestUnit = true
        formatter.maximumUnitCount = 1
        let interval = NSDate().timeIntervalSinceDate(sinceDate)
        return formatter.stringFromTimeInterval(interval)!
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
