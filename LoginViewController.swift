//
//  ViewController.swift
//
//  Created by JJ on 16/07/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import Firebase



class LoginViewController: UIViewController {
    @IBOutlet weak var userNameSignInTxtFld: UITextField!
    @IBOutlet weak var passwordSignInTxtFld: UITextField!
    
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    
    
    @IBAction func onLogInBtn(sender: UIButton) {
        guard let email = userNameSignInTxtFld.text , let password = passwordSignInTxtFld.text else{
            return
        }
        let pending = UIAlertController(title: "Logging in", message: nil, preferredStyle: .Alert)
        pending.view.alpha = 0.2
        //create an activity indicator
        let rect = CGRect(
            origin: CGPoint(x: -60, y: 0),
            size: UIScreen.mainScreen().bounds.size
        )
        let indicator = UIActivityIndicatorView()
        indicator.frame = rect
        indicator.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        indicator.activityIndicatorViewStyle.hashValue
        indicator.color = UIColor.blackColor()
        
        //add the activity indicator as a subview of the alert controller's view
        pending.view.addSubview(indicator)
        indicator.userInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
        indicator.startAnimating()
        
        self.presentViewController(pending, animated: false, completion: nil)
        
        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            if let user = user {
                User .signIn(user.uid)
                pending.dismissViewControllerAnimated(true, completion: {
                    indicator.stopAnimating()
                    self.performSegueWithIdentifier("HomeSegue", sender: nil)
                    
                })
            }else{
                pending.dismissViewControllerAnimated(true, completion:{
                    // show an alert controller to display the error(using the variable error localizedDescription)
                    let controller = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .Alert)
                    let dismissButton = UIAlertAction(title: "Try Again", style: .Default, handler: nil)
                    controller.addAction(dismissButton)
                    
                    self.presentViewController(controller, animated: true, completion: nil)})
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "SignUpSegue"
        {
            _ = segue.destinationViewController as! SignUpViewController
        } else{
            
            //            let navVc = segue.destinationViewController as! UINavigationController // 1
            //            let chatVc = navVc.viewControllers.first as! ChatViewController // 2
            //            chatVc.senderId = User.currentUserUid()  // 3
            //            chatVc.senderDisplayName = "" // 4
            //            chatVc.title = " ChatRoom"
            //            let rootRef = FIRDatabase.database().reference()
            //            var list: FIRDatabaseReference!
            //            list = rootRef.child("users")
            //            print(list)
            //
            //            print(rootRef)
            
        }
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
}




