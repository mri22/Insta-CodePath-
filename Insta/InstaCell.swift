//
//  InstaCell.swift
//  Insta
//
//  Created by Mazen Raafat Ibrahim on 6/20/16.
//  Copyright © 2016 Mazen & Andres. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Agrume

class InstaCell: UITableViewCell {
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var captionTextField: UILabel!
    @IBOutlet weak var likeNumberLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    var query = PFQuery(className: "Post")
    
    var likeNumber: Int = 0
    
    var post: PFObject?
    var index: Int?
    
    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initViews()
    }
    
    func initViews() {
        selectedBackgroundView=UIView(frame: frame)
        selectedBackgroundView!.backgroundColor = UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 0.8)
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        var size = CGSize(width: 40, height: 60)
        self.postImageView.sizeThatFits(size)
        
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.blackColor().CGColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true

    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        likeNumberLabel.text = "\(likeNumber)"
        
        
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20

        
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            
            if let posts = posts {
                // do something with the data fetched
                
                
            }
        }
        if post != nil {
            let like = self.post!["likesCount"] as! Int
            likeNumberLabel.text = "\(like)"
        }
        
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        if post != nil {
            var likes = self.post!["likes"] as! [String]
            
            if likes.contains((PFUser.currentUser()?.username)!) == false
            {
                let like = self.post!["likesCount"] as! Int
                post!["likesCount"] = like + 1
                likeNumber = self.post!["likesCount"] as! Int
                likeNumberLabel.text = "\(likeNumber)"
            
//            self.post!["likes"] = []
            
            
                likes.append((PFUser.currentUser()?.username)!)
                post!["likes"] = likes
            } else {
                
                let like = self.post!["likesCount"] as! Int
                post!["likesCount"] = like - 1
                likeNumber = self.post!["likesCount"] as! Int
                likeNumberLabel.text = "\(likeNumber)"
                
                var i: Int
                
                i = likes.indexOf((PFUser.currentUser()?.username)!)!
                likes.removeAtIndex(i)
                
                post!["likes"] = likes

            }
            
            post?.saveInBackground()
        }
        print (PFUser.currentUser())
    }
    

}
