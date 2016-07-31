//
//  SignUpViewController.swift
//  iOSChatApp
//
//  Created by JJ on 01/07/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
import QuartzCore

class SignUpViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var registeredBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var userNameSignUpTextField: UITextField!
    @IBOutlet weak var emailSignUpTextField: UITextField!
    @IBOutlet weak var passWordSignUpTextField: UITextField!
    var leftImageView = UIImageView()
    var fireBaseRef = FIRDatabase.database().reference()
    var leftView = UIView()
    let leftImageViewPw = UIImageView()
    let leftImageViewUn = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backdrop")!)
        
        leftImageView.image = UIImage(named:"basic_mail.png")
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        leftView.frame = CGRectMake(0, 0, 30, 20)
        leftImageView.frame = CGRectMake(20, 0, 15, 20)
        emailSignUpTextField.leftView = leftView
        emailSignUpTextField.leftViewMode = UITextFieldViewMode.Always
        emailSignUpTextField.layer.cornerRadius = 15.0
        emailSignUpTextField.layer.masksToBounds = true
        emailSignUpTextField.backgroundColor = UIColor(white: 1, alpha: 0.3)
        emailSignUpTextField.layer.borderColor = UIColor.grayColor().CGColor
        emailSignUpTextField.layer.borderWidth = 1.0
        
        leftImageViewPw.image = UIImage(named:"basic_lock.png")
        let leftViewPw = UIView()
        leftViewPw.addSubview(leftImageViewPw)
        leftViewPw.frame = CGRectMake(0, 0, 30, 20)
        leftImageViewPw.frame = CGRectMake(20, 0, 15, 20)
        passWordSignUpTextField.leftView = leftViewPw
        passWordSignUpTextField.leftViewMode = UITextFieldViewMode.Always
        passWordSignUpTextField.layer.cornerRadius = 15.0
        passWordSignUpTextField.layer.masksToBounds = true
        passWordSignUpTextField.backgroundColor = UIColor(white: 1, alpha: 0.3)
        passWordSignUpTextField.layer.borderColor = UIColor.grayColor().CGColor
        passWordSignUpTextField.layer.borderWidth = 1.0
        
        leftImageViewUn.image = UIImage(named:"basic_bookmark.png")
        let leftViewUn = UIView()
        leftViewUn.addSubview(leftImageViewUn)
        leftViewUn.frame = CGRectMake(0, 0, 30, 20)
        leftImageViewUn.frame = CGRectMake(20, 0, 15, 20)
        userNameSignUpTextField.leftView = leftViewUn
        userNameSignUpTextField.leftViewMode = UITextFieldViewMode.Always
        userNameSignUpTextField.layer.cornerRadius = 15.0
        userNameSignUpTextField.layer.masksToBounds = true
        userNameSignUpTextField.backgroundColor = UIColor(white: 1, alpha: 0.3)
        userNameSignUpTextField.layer.borderColor = UIColor.grayColor().CGColor
        userNameSignUpTextField.layer.borderWidth = 1.0
        
    }
    
    @IBAction func onSignUpBtn(sender: AnyObject) {
        
        guard let email = emailSignUpTextField.text, let password = passWordSignUpTextField.text, let userName = userNameSignUpTextField.text
            else{
                return
        }
        
        
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            if let user = user {
                let userDict = ["email": email,"username": userName]
                
                //do something
                self.fireBaseRef.child("users").child(user.uid).setValue(userDict)
                NSUserDefaults.standardUserDefaults().setValue(user.uid, forKeyPath: "uid")
                
                User.signIn(user.uid)
                self.performSegueWithIdentifier("HomeSegue", sender: nil)
                
            }else{
                
                let controller = UIAlertController(title: "Error", message: (error?.localizedDescription), preferredStyle: .Alert)
                let dismissBtn = UIAlertAction(title: "Try Again", style: .Default, handler: nil)
                controller.addAction(dismissBtn)
                
                self.presentViewController(controller, animated: true, completion: nil)
                
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "HomeSegue"
        {
            
        } else{
            _ = segue.destinationViewController as! LoginViewController
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.scrollView.setContentOffset(CGPointMake(0, 250), animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        
    }
}




