//
//  CardsViewController.swift
//  beepLAH
//
//  Created by JJ on 19/07/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import Firebase
import CoreImage
import MBProgressHUD

class CardsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var collectionView: UICollectionView!
    
    let firebaseRef = FIRDatabase.database().reference()
    var info = [String]()
    var cards = [Card]()
    var usersSet = Set<String>()
    var myActivityIndicator = UIActivityIndicatorView()
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
        let spinnerActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true);
        
        spinnerActivity.labelText = "Loading";
        
        spinnerActivity.userInteractionEnabled = false;
//        self.myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
//        myActivityIndicator.center = view.center
//        myActivityIndicator.startAnimating()
//        view.addSubview(myActivityIndicator)
        self.cards.removeAll()
        self.usersSet.removeAll()
        self.tabBarController?.tabBar.hidden = false
        getUserSets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cards.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("CardCell", forIndexPath: indexPath) as! CardCollectionViewCell
        let selectedItems = self.cards[indexPath.row]
        cell.cardMerchantName.text = selectedItems.name
        cell.cardImage.image = UIImage(named: selectedItems.name!)
        cell.cardNumber.text = selectedItems.No
        let image = generateQRCodeFromString(selectedItems.No! +  selectedItems.ownerName!)
        cell.QRImageView.image = image
        return cell
    }
    
    func getUserCardInfo() {
        let cardInfo = firebaseRef.child("cards")
        cardInfo.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if self.usersSet.contains(snapshot.key) {
                if let cardInfos = snapshot.value as? [String:AnyObject] {
                    let card = Card()
                    let cardOwner = cardInfos["Card Owner"] as! String
                    card.ownerName = cardOwner
                    let name = cardInfos["Name"] as! String
                    card.name = name
                    let cardNo = cardInfos["CardNo"] as! String
                    card.No = cardNo
                    let expDate = cardInfos["Card Expiry Date"] as! String
                    card.expDate = expDate
                    let points =  cardInfos["Points"] as! String
                    card.point = points
                    self.cards.append(card)
                    self.collectionView.reloadData()
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true);
                    
                }
            }
            
        })
        
    }
    
    func generateQRCodeFromString(string: String) -> UIImage? {
        let data = string.dataUsingEncoding(NSISOLatin1StringEncoding)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel")
            let transform = CGAffineTransformMakeScale(10, 10)
            
            if let output = filter.outputImage?.imageByApplyingTransform(transform) {
                return UIImage(CIImage: output)
            }
        }
        
        return nil
    }
    
    func getUserSets() {
        let userInfo = firebaseRef.child("users").child(User.currentUserUid()!).child("UserCards")
        userInfo.observeEventType(.Value, withBlock: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                for (key, _) in dict{
                    self.usersSet.insert(key)
                }
            }
            self.getUserCardInfo()
        })
        
        
    }
    @IBAction func settingsBtn(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: "Settings", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Profile", style: .Default) { (action) in
           self.performSegueWithIdentifier("ProfileSegue", sender: self)
        }
        alertController.addAction(OKAction)
        
        let logOutAction = UIAlertAction(title: "Log Out", style: .Default) { (action) in
            try! FIRAuth.auth()!.signOut()
            User.removeUserUid()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let navigationController = storyboard.instantiateViewControllerWithIdentifier("RootViewController") as? UIViewController{
                self.presentViewController(navigationController, animated: true, completion: nil)
            }
            
        
        }
        alertController.addAction(logOutAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    @IBAction func unwindToCardView(segue: UIStoryboardSegue) {}
    
}
