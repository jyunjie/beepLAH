//
//  SignUpViewController.swift
//  iOSChatApp
//
//  Created by JJ on 01/07/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var userNameSignUpTextField: UITextField!
    @IBOutlet weak var emailSignUpTextField: UITextField!
    @IBOutlet weak var passWordSignUpTextField: UITextField!
    var fireBaseRef = FIRDatabase.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onSignUpBtn(sender: AnyObject) {
        
        guard let email = emailSignUpTextField.text, let password = passWordSignUpTextField.text, let userName = userNameSignUpTextField.text
            else{
                return
        }
        let pending = UIAlertController(title: "Signing Up", message: nil, preferredStyle: .Alert)
        pending.view.alpha = 0.2
        
        //create an activity indicator
        let rect = CGRect(
            origin: CGPoint(x: -60, y: 0),
            size: UIScreen.mainScreen().bounds.size
        )
        let indicator = UIActivityIndicatorView()
        indicator.frame = rect
        print(pending.view.bounds)
        indicator.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        indicator.activityIndicatorViewStyle.hashValue
        indicator.color = UIColor.blackColor()
        
        //add the activity indicator as a subview of the alert controller's view
        pending.view.addSubview(indicator)
        indicator.userInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
        indicator.startAnimating()
        self.presentViewController(pending, animated: false, completion: nil)
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            if let user = user {
                let userDict = ["email": email,"username": userName]
                
                //do something
                self.fireBaseRef.child("users").child(user.uid).setValue(userDict)
                NSUserDefaults.standardUserDefaults().setValue(user.uid, forKeyPath: "uid")
                
                User.signIn(user.uid)
                indicator.stopAnimating()
                pending.dismissViewControllerAnimated(true, completion: {
                    self.performSegueWithIdentifier("HomeSegue", sender: nil)
                })
                
                
            }else{
                pending.dismissViewControllerAnimated(true, completion: {
                    
                    
                    let controller = UIAlertController(title: "Error", message: (error?.localizedDescription), preferredStyle: .Alert)
                    let dismissBtn = UIAlertAction(title: "Try Again", style: .Default, handler: nil)
                    controller.addAction(dismissBtn)
                    
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "HomeSegue"
        {
            //            let navVc = segue.destinationViewController as! UINavigationController // 1
            //            let chatVc = navVc.viewControllers.first as! ChatViewController // 2
            //            chatVc.senderId = User.currentUserUid()  // 3
            //            let username = fireBaseRef.child("username")
            //            chatVc.senderDisplayName = "ChatRoom" // 4
            //            chatVc.title = " ChatRoom"
            
            
        } else{
            
            _ = segue.destinationViewController as! LoginViewController
            
        }
    }
}




