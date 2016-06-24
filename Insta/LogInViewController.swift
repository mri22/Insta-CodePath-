//
//  LogInViewController.swift
//  Insta
//
//  Created by Mazen Raafat Ibrahim on 6/18/16.
//  Copyright © 2016 Mazen. All rights reserved.
//

import UIKit
import Parse
import SkyFloatingLabelTextField

class LogInViewController: UIViewController {
    
    @IBOutlet weak var usernameField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let overcastBlueColor = UIColor(red: 0, green: 1.0, blue: 0.35, alpha: 1.0)
        
        
        usernameField.placeholder = "username"
        usernameField.title = "Username"
        usernameField.lineColor = overcastBlueColor
        usernameField.textColor = overcastBlueColor
        usernameField.selectedTitleColor = overcastBlueColor
        self.view.addSubview(usernameField)
        
        passwordField.placeholder = "password"
        passwordField.title = "Password"
        passwordField.lineColor = overcastBlueColor
        passwordField.textColor = overcastBlueColor
        passwordField.selectedTitleColor = overcastBlueColor
        self.view.addSubview(passwordField)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("you're logged in!")
                
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
        }
    }
    
    @IBAction func onRegister(sender: AnyObject) {
        let newUser = PFUser()
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                print("yay")
                
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            } else {
                print(error?.localizedDescription)
                if error?.code == 202 {
                    print("User name is already taken")
                    
                }
            }
            
        }
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
