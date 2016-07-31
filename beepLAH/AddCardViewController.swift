//
//  AddCardViewController.swift
//  beepLAH
//
//  Created by JJ on 21/07/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import Firebase

class AddCardViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    let firebaseRef = FIRDatabase.database().reference()
    var merchantList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        merchantInfo()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.merchantList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("AddCardCell", forIndexPath: indexPath) as! AddCardTableViewCell
        let items = self.merchantList[indexPath.row]
//        cell.cardLabel.text = items
        cell.cardImage.image = UIImage(named: items)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        //1. Create the alert controller.
        let alert = UIAlertController(title: self.merchantList[indexPath.row], message: "Please fill in your information", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (cardOwnertextField) -> Void in
            cardOwnertextField.placeholder = "Card Owner"
        })
        
        alert.addTextFieldWithConfigurationHandler({ (cardNotextField) -> Void in
            cardNotextField.placeholder = "Card Number"
        })
        
        alert.addTextFieldWithConfigurationHandler({ (cardExpDatetextField) -> Void in
            cardExpDatetextField.placeholder = "Card Expiry Date"
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let cardOwnertextField = alert.textFields![0] as UITextField
            let cardNotextField = alert.textFields![1] as UITextField
            let cardExpDatetextField = alert.textFields![2] as UITextField
            
            let cardUID = NSUUID().UUIDString
            let cardsInfoRef = self.firebaseRef.child("cards").child(cardUID)
            let cardDict = ["Card Owner":cardOwnertextField.text!,"Name":(self.merchantList[indexPath.row]),"CardNo":cardNotextField.text!,"Card Expiry Date": cardExpDatetextField.text!,"Points":"1000"] as [String:AnyObject]
            cardsInfoRef.setValue(cardDict)
            self.firebaseRef.child("users").child(User.currentUserUid()!).child("UserCards").child(cardUID).setValue(true)
            self.navigationController?.popViewControllerAnimated(true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {(ACTION) -> Void in
        }))
        
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func merchantInfo() {
        let merchantRef = firebaseRef.child("merchant")
        merchantRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let merchantName = snapshot.key as String
            self.merchantList.append(merchantName)
            self.tableView.reloadData()
        })
    }
    @IBAction func unWind(sender: UIBarButtonItem) {
//        if let navigationController = storyboard!.instantiateViewControllerWithIdentifier("CardViewController") as? UIViewController{
//            self.presentViewController(navigationController, animated: true, completion: nil)
//        }
        navigationController?.popViewControllerAnimated(true)
    }
}
