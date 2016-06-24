//
//  ProfileCell.swift
//  Insta
//
//  Created by Mazen Raafat Ibrahim on 6/22/16.
//  Copyright © 2016 Mazen. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileCell: UITableViewCell {

    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var captionTextField: UILabel!
    //@IBOutlet weak var likeNumberLabel: UILabel!
    
    var query = PFQuery(className: "Post")
    
    var likeNumber: Int = 0
    
    var post: PFObject?
    
    var index: Int?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        
        query.limit = 20
        
        
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            
            if let posts = posts {
                // do something with the data fetched
                
            }
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
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
    
    /*@IBAction func likeButtonTapped(sender: AnyObject) {
        likeNumber += 1
        likeNumberLabel.text = "\(likeNumber)"
        //if post!["likesCount"] != nil {
        //    post!["likesCount"] = self.likeNumber
        //    print("\(post!["likesCount"])")
        // }
        
    }*/
    
}
