//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Emily Garcia on 3/5/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var currUser: User?
    var tweets: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currUser = User.current
        let profilePic = URL(string:(currUser?.profileImage)!)!
        profileImageView.af_setImage(withURL: profilePic)
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        
        nameLabel.text = currUser?.name
        screenNameLabel.text = currUser?.screenName
        taglineLabel.text = currUser?.description
        followingCountLabel.text = String(describing: currUser?.followingCount as! Int)
        followerCountLabel.text = String(describing: currUser?.followersCount as! Int)
        tweetCountLabel.text = String(describing: currUser?.tweetCount as! Int)
        
        // set up table view
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        fetchData()
    }

    @objc func fetchData(){
        // call api to get new tweets
        APIManager.shared.getUserTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        cell.profilePicImageView.layer.masksToBounds = false
        cell.profilePicImageView.layer.cornerRadius = cell.profilePicImageView.frame.size.width/2
        cell.profilePicImageView.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
