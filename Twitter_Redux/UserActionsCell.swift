//
//  UserActionsCell.swift
//  Twitter
//
//  Created by Matthew Goo on 10/4/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

@objc protocol UserActionsCellDelegate {
    optional func userActionsCellDelegate(userActionsCell: UserActionsCell, didTapRetweet tweet: Tweet)
    optional func userActionsCellDelegate(userActionsCell: UserActionsCell, didTapFavorite tweet: Tweet)
    optional func userActionsCellDelegate(userActionsCell: UserActionsCell, didTapReply tweet: Tweet)
}

class UserActionsCell: UITableViewCell {
    
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    
    weak var delegate: UserActionsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapRetweetRecognizer = UITapGestureRecognizer(target: self, action: "onRetweetTap:")
        retweetImageView.userInteractionEnabled = true
        retweetImageView.addGestureRecognizer(tapRetweetRecognizer)
        
        let tapFavoriteRecognizer = UITapGestureRecognizer(target: self, action: "onFavoriteTap:")
        favoriteImageView.userInteractionEnabled = true
        favoriteImageView.addGestureRecognizer(tapFavoriteRecognizer)
        
        let tapReplyRecognizer = UITapGestureRecognizer(target: self, action: "onReplyTap:")
        replyImageView.userInteractionEnabled = true
        replyImageView.addGestureRecognizer(tapReplyRecognizer)
    }
    
    var tweet: Tweet! {
        didSet {
            if tweet.favorited == true {
                favoriteImageView.image = UIImage(named: "favorite_on")
            }
            if tweet.retweeted == true {
                retweetImageView.image = UIImage(named: "retweet_on")
            }
        }
    }
    
    func onRetweetTap(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.userActionsCellDelegate?(self, didTapRetweet: tweet)
    }
    
    func onFavoriteTap(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.userActionsCellDelegate?(self, didTapFavorite: tweet)
    }
    
    func onReplyTap(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.userActionsCellDelegate?(self, didTapReply: tweet)
    }
    
}
