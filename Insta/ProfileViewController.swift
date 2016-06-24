//
//  ProfileViewController.swift
//  Insta
//
//  Created by Mazen Raafat Ibrahim on 6/20/16.
//  Copyright © 2016 Mazen. All rights reserved.
//

import UIKit
import Parse
import ParseUI



class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var usernameTextLabel: UILabel!
    @IBOutlet weak var ageTextLabel: UILabel!
    @IBOutlet weak var numberOfPostsTextLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    var post: PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        
        
        let query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
        
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // do something with the data fetched
                print("\(posts![0]) hellloooooooooo")
                let post = posts![0]
                self.usernameTextLabel.text = PFUser.currentUser()?.username
                let parsedImage = post["profile_picture"] as? PFFile
                self.profileImageView.file = parsedImage
                self.profileImageView.loadInBackground()
            } else {
                // handle error
                print("errrrrroorrrrr")
            }
        }

        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.greenColor().CGColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        // Do any additional setup after loading the view.
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogOut(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            
        }
    }
    
    @IBAction func onchangeProfilePic(sender: AnyObject) {
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.contentMode = .ScaleAspectFit
            profileImageView.image = pickedImage
            
            profileImageView.layer.borderWidth = 1
            profileImageView.layer.masksToBounds = false
            profileImageView.layer.borderColor = UIColor.blackColor().CGColor
            profileImageView.layer.cornerRadius = profileImageView.frame.height/2
            profileImageView.clipsToBounds = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitProfileTapped(sender: AnyObject) {
        let user = PFUser.currentUser()
        user!["profile_picture"] = getPFFileFromImage(profileImageView.image)
        user?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
            
        })
        
    }
    
    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
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
