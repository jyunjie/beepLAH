//
//  ViewController.swift
//  iOSChatApp
//
//  Created by JJ on 01/07/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD


class LoginViewController: UIViewController {
    @IBOutlet weak var emailSignInTxtFld: UITextField!
    @IBOutlet weak var passwordSignInTxtFld: UITextField!
    
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    
    
    @IBAction func onLogInBtn(sender: UIButton) {
        guard let email = emailSignInTxtFld.text , let password = passwordSignInTxtFld.text else{
            return
        }
        let spinnerActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true);
        
        spinnerActivity.labelText = "Loading";
        
        spinnerActivity.userInteractionEnabled = false;

        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            if let user = user {
                User.signIn(user.uid)
                //                pending.dismissViewControllerAnimated(true, completion: {
                //                    indicator.stopAnimating()
                
                self.performSegueWithIdentifier("HomeSegue", sender: nil)
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true);
                
                //                })
            }else{
                //                pending.dismissViewControllerAnimated(true, completion:{
                // show an alert controller to display the error(using the variable error localizedDescription)
                let controller = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .Alert)
                let dismissButton = UIAlertAction(title: "Try Again", style: .Default, handler: nil)
                controller.addAction(dismissButton)
                
                self.presentViewController(controller, animated: true, completion: nil)
                //            })
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "SignUpSegue"
        {
            _ = segue.destinationViewController as! SignUpViewController
        }
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
}




