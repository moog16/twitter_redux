//
//  TweetStatusCell.swift
//  Twitter
//
//  Created by Matthew Goo on 10/4/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

class TweetStatusCell: UITableViewCell {
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritedCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var tweet: Tweet! {
        didSet {
            if let retweetCount = tweet.retweetCount {
                retweetCountLabel.text = "\(retweetCount)"
            }
            if let favoriteCount = tweet.favoriteCount {
                favoritedCountLabel.text = "\(favoriteCount)"
            }
        }
    }
}
