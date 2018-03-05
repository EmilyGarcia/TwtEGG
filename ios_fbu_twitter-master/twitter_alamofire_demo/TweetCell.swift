//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            nameLabel.text = tweet.user.name
            screenNameLabel.text = "@" + tweet.user.screenName
            createdAtLabel.text = tweet.createdAtString
            let picUrl = URL(string: tweet.user.profileImage)
            profilePicImageView.af_setImage(withURL: picUrl!)
            refreshData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        if tweet.favorited == false {
            // update model
            tweet.favorited = true
            tweet.favoriteCount = tweet.favoriteCount! + 1
            print(tweet.favoriteCount!)
            
            // update UI
            self.favoriteButton.isSelected = true
            
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
            }
        }
        else {
            // update model
            tweet.favorited = false
            tweet.favoriteCount = tweet.favoriteCount! - 1
            print(tweet.favoriteCount!)
            
            // update UI
            self.favoriteButton.isSelected = false
            
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                    tweet.favorited = false

                    self.favoriteButton.isSelected = false
                }
            }
        }
        refreshData()
    }
    
    @IBAction func didTapRetweet(_ sender: Any) {
        print(tweet.retweeted)
        if tweet.retweeted == false {
            // update model
            tweet.retweeted = true
            tweet.retweetCount = tweet.retweetCount + 1
            print(tweet.retweetCount)
            
            // update UI
            self.retweetButton.isSelected = true
            
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                }
            }
        }
        else {
            // update model
            tweet.retweeted = false
            tweet.retweetCount = tweet.retweetCount - 1
            
            // update UI mode
            self.retweetButton.isSelected = false
            
            APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error untweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully untweeted the following Tweet: \n\(tweet.text)")
                }
            }
        }
        // update UI
        refreshData()
        
    }
    
    func refreshData(){
        // refresh favorites
        favoriteCountLabel.text = String(describing: tweet.favoriteCount!)
        if (tweet.favorited == true) {
            favoriteButton.setImage(UIImage(named: "favor-icon-red.png"), for: [])
        }
        else {
            favoriteButton.setImage(UIImage(named: "favor-icon.png"), for: [])
        }
        
        // refresh retweet
        retweetCountLabel.text = String(tweet.retweetCount)
        if (tweet.retweeted == true) {
            retweetButton.setImage(UIImage(named: "retweet-icon-green.png"), for: [])
        }
        else {
            retweetButton.setImage(UIImage(named: "retweet-icon.png"), for: [])
        }
    }
    
}
