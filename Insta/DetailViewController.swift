//
//  DetailViewController.swift
//  Insta
//
//  Created by Mazen Raafat Ibrahim on 6/20/16.
//  Copyright © 2016 Mazen. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DetailViewController: UIViewController {
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var post: PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let post = post {
        let parsedImage = post["media"] as! PFFile
            
            self.postImageView.file = parsedImage
            self.commentLabel.text = post["caption"].description
            self.timestampLabel.text = post.createdAt?.description
            //let date = post["_created_at"]
            //self.dateLabel.text = date["date"].description
            
            self.postImageView.loadInBackground()
        } else {
            print ("error")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
