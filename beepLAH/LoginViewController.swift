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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
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
                print(self.view.backgroundColor)
                self.performSegueWithIdentifier("HomeSegue", sender: nil)
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true);
                
                //                })
            }else{
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
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
    
    func keyboardWillShow(notification: NSNotification) {
        
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()) != nil {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= 150
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()) != nil {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += 150
            }
            else {
                
            }
        }
    }
    
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
}




