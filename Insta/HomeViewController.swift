//
//  HomeViewController.swift
//  Insta
//
//  Created by Mazen Raafat Ibrahim on 6/19/16.
//  Copyright © 2016 Mazen. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD
import SVPullToRefresh
import SkyFloatingLabelTextField

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!

    
    var posts : [PFObject]?
    
    var postsUser: [PFObject]?
    
    var postsUsers: [PFObject]?
    
    let HeaderViewIdentifier = "TableViewHeaderView"
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
//        tableView.backgroundView = UIImageView(image: UIImage(named: "instagram"))
        
        
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        let queryUser = PFQuery(className: "_User")
        queryUser.findObjectsInBackgroundWithBlock { (postsUser: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // do something with the data fetched
                
                self.postsUsers = postsUser
                //print("\(self.postsUser!) ussssseeerrr")
            } else {
                // handle error
                print("errrrrroorrrrr")
            }
        }
        
        
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        loadMoreData()
        tableView.reloadData()
        
        
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InstaCell", forIndexPath: indexPath) as! InstaCell
        
        
        let post = posts![indexPath.row]
        let parsedImage = post["media"] as? PFFile
        let parsedCaption = post["caption"]
        let parsedTimestamp = post.createdAt
        cell.postImageView.file = parsedImage
        cell.captionTextField.text = parsedCaption.description
        print(cell.captionTextField)
        cell.post = post
        cell.timestampLabel.text = parsedTimestamp?.description
        cell.likeNumberLabel.text = "\(post["likesCount"])"
        
        if let postsUser = self.postsUsers {
            for user in self.postsUsers! {
                if post["username"].description == user["username"].description {
                    let parsedImageUser = user["profile_picture"] as? PFFile
                    cell.profileImageView.file = parsedImageUser
                    
                }
            }
        }
        
        cell.usernameLabel.text = post["username"].description
        cell.postImageView.loadInBackground()
        cell.profileImageView.loadInBackground()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.greenColor()
        cell.selectedBackgroundView = backgroundView
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = self.posts {
            return posts.count
        } else {
            return 0
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            
            if let posts = posts {
                // do something with the data fetched
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.posts = posts
                self.tableView.reloadData()
                 refreshControl.endRefreshing()
               
            } else {
                // handle error
            }
        
        }
        
        let queryUser = PFQuery(className: "_User")
        queryUser.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
        
        
        // fetch data asynchronously
        queryUser.findObjectsInBackgroundWithBlock { (postsUser: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // do something with the data fetched
                print("\(postsUser![0]) ussssseeerrr")
                let postUser = postsUser![0]
                self.postsUser = postsUser
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            } else {
                // handle error
                print("errrrrroorrrrr")
            }
        }

    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.blueColor()
        vw.sizeToFit()
        
        return vw
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.alpha = 0
        var transform = CATransform3DTranslate(CATransform3DIdentity
            , -250, 20, 0)
        
        UIView.animateWithDuration(1.25) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()

                
                fetchMoreData()
            }
        }
    }
    
    func fetchMoreData() {
        
        
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        query.skip = (posts?.count)!
        
        
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            
            self.isMoreDataLoading = false
            if let posts = posts {
                // do something with the data fetched
                self.posts?.appendContentsOf(posts)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.loadingMoreView!.stopAnimating()
                self.tableView.reloadData()
                
            } else {
                // handle error
            }
            
        }

    }
    
    func loadMoreData() {
            
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            
            self.isMoreDataLoading = false
            self.loadingMoreView!.stopAnimating()
            if let posts = posts {
                // do something with the data fetched
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.posts = posts
                self.tableView.reloadData()
                
            } else {
                // handle error
            }
            
        }
        
        
        let queryUser = PFQuery(className: "_User")
        queryUser.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
        
        
        // fetch data asynchronously
        queryUser.findObjectsInBackgroundWithBlock { (postsUser: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // do something with the data fetched
                
                self.postsUser = postsUser
                print("\(self.postsUser!) ussssseeerrr")
                let postUser = postsUser![0]
                self.tableView.reloadData()
            } else {
                // handle error
                print("errrrrroorrrrr")
            }
        }
        


            
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailViewControllerSegue" {
            let cell = sender as! InstaCell
            let indexPath = tableView.indexPathForCell(cell)
            let post = posts![indexPath!.row]
            
            
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.post = post
        }

    }
}