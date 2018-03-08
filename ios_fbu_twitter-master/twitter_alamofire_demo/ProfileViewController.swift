//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Emily Garcia on 3/5/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    
    var currUser: User?
    
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
        
    }

    @objc func fetchData(){
        // call api to get new tweets
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
