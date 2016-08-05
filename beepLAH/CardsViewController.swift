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

class CardsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UIPopoverPresentationControllerDelegate {
    @IBOutlet var collectionView: UICollectionView!
    
    let firebaseRef = FIRDatabase.database().reference()
    var info = [String]()
    var cards = [Card]()
    var usersSet = Set<String>()
    var selectedItems = Card()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backdrop")!)
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.tabBarController?.tabBar.layer.borderWidth = 0.5
        self.tabBarController?.tabBar.layer.borderColor = UIColor.blackColor().CGColor
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
//        self.tabBarController?.tabBar.barTintColor = UIColor.init(red: 0, green: 0.505086, blue: 1, alpha: 1)
        self.tabBarController?.tabBar.tintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.blackColor()]
        let spinnerActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinnerActivity.labelText = "Loading"
        spinnerActivity.userInteractionEnabled = false
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
        cell.cardOwner.text = selectedItems.ownerName
        cell.cardImage.image = UIImage(named: selectedItems.name!)
        cell.cardExpDate.text = selectedItems.expDate
        cell.cardNumber.text = selectedItems.point
        
        //        cell.QRImageView.image = image
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
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true);
                    self.collectionView.reloadData()
                    self.saveCurrentCard()                    
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
    
//    -(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    float currentPage = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
//    self.pageControl.currentPage = ceil(currentPage);
//    
//    NSLog(@"Values: %f %f %f", self.collectionView.contentOffset.x, self.collectionView.frame.size.width, ceil(currentIndex));
//    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        saveCurrentCard()
    }
    
    func saveCurrentCard(){
        let currentPage = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
        let index = Int(currentPage)
        
        let card = cards[index]
        
        Card.currentCard = card
    }
    
    func getUserSets() {
        let userInfo = firebaseRef.child("users").child(User.currentUserUid()!).child("UserCards")
        userInfo.observeEventType(.Value, withBlock: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                for (key, _) in dict{
                    self.usersSet.insert(key)
                }
            }
            if self.usersSet.count == 0 {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true);
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedItems = self.cards[indexPath.row]
        print(indexPath.row)
        let vc = storyboard?.instantiateViewControllerWithIdentifier("popOverController") as! PopOverViewController
        vc.preferredContentSize = CGSizeMake(350,260)
        vc.array = self.selectedItems
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = UIModalPresentationStyle.Popover
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CardCollectionViewCell else {return}
        let popOver = navController.popoverPresentationController
        popOver?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        popOver?.backgroundColor = UIColor.init(white: 1, alpha: 0.3)
        popOver?.sourceView = cell.cardImage
        popOver?.sourceRect = CGRectMake(0,110,0,0)
        popOver?.delegate = self
        
        self.presentViewController(navController, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        if let dest = segue.destinationViewController as? PopOverViewController{
        //
        //        }
    }
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    //    {
    //        if segue.identifier == "showSegue"
    //        {
    //            let vc = segue.destinationViewController as! QRViewController
    //            let controller = vc.popoverPresentationController
    //            vc.array = self.selectedItems
    //            if controller != nil
    //            {
    //                controller?.delegate = self
    //            }
    //        }
    //    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
    @IBAction func unwindToCardView(segue: UIStoryboardSegue) {}
    
    
}

