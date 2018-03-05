//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet] = []
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up activity indicator
        self.activityIndicator.startAnimating()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TimelineViewController.didPullToRefresh(_:) ), for: . valueChanged)
        didPullToRefresh(refreshControl)
        tableView.insertSubview(refreshControl, at: 0)
        
        // set up table view
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    @objc func didPullToRefresh(_ refreshControl:  UIRefreshControl){
        // call api to get new tweets
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
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
