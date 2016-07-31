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
import QuartzCore


class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailSignInTxtFld: UITextField!
    @IBOutlet weak var passwordSignInTxtFld: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    let leftImageView = UIImageView()
    let leftImageViewPw = UIImageView()

    

    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backdrop")!)
        leftImageView.image = UIImage(named:"basic_mail.png")
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        leftView.frame = CGRectMake(0, 0, 30, 20)
        leftImageView.frame = CGRectMake(20, 0, 15, 20)
        emailSignInTxtFld.leftView = leftView
        emailSignInTxtFld.leftViewMode = UITextFieldViewMode.Always
        emailSignInTxtFld.layer.cornerRadius = 15.0
        emailSignInTxtFld.layer.masksToBounds = true
        emailSignInTxtFld.backgroundColor = UIColor(white: 1, alpha: 0.3)
        emailSignInTxtFld.layer.borderColor = UIColor.grayColor().CGColor
        emailSignInTxtFld.layer.borderWidth = 1.0
        
        leftImageViewPw.image = UIImage(named:"basic_lock.png")
        let leftViewPw = UIView()
        leftViewPw.addSubview(leftImageViewPw)
        leftViewPw.frame = CGRectMake(0, 0, 30, 20)
        leftImageViewPw.frame = CGRectMake(20, 0, 15, 20)
        passwordSignInTxtFld.leftView = leftViewPw
        passwordSignInTxtFld.leftViewMode = UITextFieldViewMode.Always
        passwordSignInTxtFld.layer.cornerRadius = 15.0
        passwordSignInTxtFld.layer.masksToBounds = true
        passwordSignInTxtFld.backgroundColor = UIColor(white: 1, alpha: 0.3)
        passwordSignInTxtFld.layer.borderColor = UIColor.grayColor().CGColor
        passwordSignInTxtFld.layer.borderWidth = 1.0
        
    }
    
    
    
    @IBAction func onLogInBtn(sender: UIButton) {
        dismissKeyboard()
        self.scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        guard let email = emailSignInTxtFld.text , let password = passwordSignInTxtFld.text else{
            return
        }
        let spinnerActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true);
        
        spinnerActivity.labelText = "Logging in, please wait..";
        
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
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "SignUpSegue"
        {
            dismissKeyboard()
            self.scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
            _ = segue.destinationViewController as! SignUpViewController
        }
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.scrollView.setContentOffset(CGPointMake(0, 250), animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.scrollView.setContentOffset(CGPointMake(0, 0), animated: true)

    }
    
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
}




