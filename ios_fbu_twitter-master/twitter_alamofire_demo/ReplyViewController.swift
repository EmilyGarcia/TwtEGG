//
//  ReplyViewController.swift
//  twitter_alamofire_demo
//
//  Created by Emily Garcia on 3/7/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import UITextView_Placeholder;

protocol ReplyViewControllerDelegate: NSObjectProtocol {
    func did(post: Tweet)
}

class ReplyViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var submitTweetButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    weak var delegate: ReplyViewControllerDelegate?
    @IBOutlet weak var charCountLabel: UILabel!

    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitTweetButton.layer.cornerRadius = 15
        submitTweetButton.titleEdgeInsets = UIEdgeInsetsMake(1.5, 1.0, 1.5, 1.0)
        
        textView.placeholder = "What's happening?"
        textView.placeholderColor = UIColor.lightGray // optional
        
        profileImageView.af_setImage(withURL: URL(string: (User.current?.profileImage)!)!)
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        
        textView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapReply(_ sender: Any) {
        let tweetText = textView.text
        APIManager.shared.replyTweet(with: tweetText!, with: tweet.idString) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                print("Reply Tweet Success!")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // TODO: Check the proposed new text character count
        // Allow or disallow the new text
        
        // Set the max character limit
        let characterLimit = 140
        
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        
        // TODO: Update Character Count Label
        charCountLabel.text = String(characterLimit - newText.characters.count)
        
        // The new text should be allowed? True/False
        return newText.characters.count < characterLimit
    }

}
