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

class CardsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var collectionView: UICollectionView!
    
    let firebaseRef = FIRDatabase.database().reference()
    var info = [String]()
    var cards = [Card]()
    var usersSet = Set<String>()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = false
        getUserSets()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOut(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        User.removeUserUid()
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
        let image = generateQRCodeFromString(selectedItems.No!)
        cell.QRImageView.image = image
        return cell
    }
    
    func getUserCardInfo() {
        let cardInfo = firebaseRef.child("cards")
        cardInfo.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            //            let cardUIDs = snapshot.key
            if self.usersSet.contains(snapshot.key) {
                if let cardInfos = snapshot.value as? [String:AnyObject] {
                    let card = Card()
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
        print(userInfo)
        userInfo.observeEventType(.Value, withBlock: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                for (key, _) in dict{
                    self.usersSet.insert(key)
                }
            }
            self.getUserCardInfo()
        })
        
        
    }
    

    
    
}
