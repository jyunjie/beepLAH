//
//  CardsViewController.swift
//  beepLAH
//
//  Created by JJ on 19/07/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import Firebase

class CardsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var collectionView: UICollectionView!

    let firebaseRef = FIRDatabase.database().reference()
    var info = [String]()
    var cards = [Card]()
    var card = Card()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserCardInfo()
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
        cell.cardNumber.text = selectedItems.No
        return cell
    }

    func getUserCardInfo() {
        let cardInfo = firebaseRef.child("cards")
        cardInfo.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let cardInfos = snapshot.value as? [String:AnyObject] {
                let name = cardInfos["Name"] as! String
                self.card.name = name
                let cardNo = cardInfos["CardNo"] as! String
                self.card.No = cardNo
                self.cards.append(self.card)
                self.collectionView.reloadData()
            }
        })
    }
}
