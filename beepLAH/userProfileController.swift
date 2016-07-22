//
//  userProfileController.swift
//  beepLAH
//
//  Created by JIA YIAO GOH on 22/07/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import Firebase


class userProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    

    let firebaseRef = FIRDatabase.database().reference()
    let userUID = User.currentUserUid()
    
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath)
        cell.textLabel?.text = "Username"
        cell.detailTextLabel?.text = "Jason"
        
        return cell
    }
//
//        
//        func getUserInfo() {
//            let userName = firebaseRef.child("users")
//            userName.observeEventType(.ChildAdded, withBlock: { (snaphot) in
//                if let userName = snapshot.value as?
//                    [String:AnyObject]{
//                    let name = userName["Name"] as!
//                    String
//                    self.userUID.name = name
//                }
//            })
}

