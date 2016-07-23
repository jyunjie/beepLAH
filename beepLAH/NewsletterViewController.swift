//
//  NewsletterViewController.swift
//  beepLAH
//
//  Created by JJ on 21/07/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import Firebase

class NewsletterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let firebaseRef = FIRDatabase.database().reference()
    var usersSet = Set<String>()
    var cards = [Card]()
    @IBOutlet var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserSets()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return self.cards.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("NewsletterCell", forIndexPath: indexPath) as! NewsletterCollectionViewCell
        let selectedItems = self.cards[indexPath.row]
        cell.cardImageView.image = UIImage(named: selectedItems.name!)
        if selectedItems.name == "Starbucks"{
            cell.newsletterPosterImageView.image = UIImage(named:"posterstarbuck")
        } else if selectedItems.name == "Golden Screen Cinemas"{
            cell.newsletterPosterImageView.image = UIImage(named:"postergoldenscreencinemas")
        } else if selectedItems.name == "Bonuslink"{
            cell.newsletterPosterImageView.image = UIImage(named:"posterbonuslink")
        }
        return cell
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
}
