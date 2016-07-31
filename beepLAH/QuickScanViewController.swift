//
//  CameraViewController.swift
//  FakeStagram
//
//  Created by JJ on 05/07/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import Fusuma
import SwiftyJSON
import Firebase

class QuickScanViewController: UIViewController, FusumaDelegate {
    
    let firebaseRef = FIRDatabase.database().reference()
    var API_KEY = "AIzaSyBBqgYGug-ksuN5Yefmcf8ACSj_isZ-5Ls"
    var firstLaunch = true
    var word = ""
    var set = Set<String>()
    var finalValue = String()
    var cardValue = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraOn()
        finalValue = ""
        cardValue = ""
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        finalValue = ""
        cardValue = ""
        self.set.removeAll()
        if firstLaunch{
            cameraOn()
        }
    }
    
    func fusumaClosed() {
        self.tabBarController?.selectedIndex = 0
        firstLaunch = true
    }
    
    func fusumaImageSelected(image: UIImage) {
        
        // Base64 encode the image and create the request
        let binaryImageData = base64EncodeImage(image)
        createRequest(binaryImageData)
        self.tabBarController?.selectedIndex = 0
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        
        print("Called just after a video has been selected.")
    }
    
    func cameraOn() {
        //        firstLaunch = false
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.hasVideo = false // If you want to let the users allow to use video.
        self.presentViewController(fusuma, animated: true, completion: nil)
    }
    
    func base64EncodeImage(image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.length > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSizeMake(800, oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedStringWithOptions(.EncodingEndLineWithCarriageReturn)
    }
    
    func resizeImage(imageSize: CGSize, image: UIImage) -> NSData {
        UIGraphicsBeginImageContext(imageSize)
        image.drawInRect(CGRectMake(0, 0, imageSize.width, imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func analyzeResults(dataToParse: NSData) {
        
        // Update UI on the main thread
        dispatch_async(dispatch_get_main_queue(), {
            var cardNum = [String]()
            
            // Use SwiftyJSON to parse results
            let json = JSON(data: dataToParse)
            //            print(json)
            let errorObj: JSON = json["error"]
            
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
                print("Error code \(errorObj["code"]): \(errorObj["message"])")
            } else {
                // Parse the response
                //                print(json)
                let responses: JSON = json["responses"][0]
                
                // Get label annotations
                let labelAnnotations: JSON = responses["textAnnotations"]
                print(labelAnnotations)
                let textValue = labelAnnotations[0]["description"].stringValue
                //                print(textValue)
                let numLabels: Int = labelAnnotations.count
                var labels: Array<String> = []
                if numLabels > 0 {
                    var labelResultsText:String = "Labels found: "
                    for index in 0..<numLabels {
                        let label = labelAnnotations[index]["description"].stringValue
                        labels.append(label)
                        self.set.insert(label)
                        if label.characters.count == 4 {
                            for char in label.utf16 {
                                if char >= 48 && char <= 57 {
                                    cardNum.append(label)
                                    
                                    break
                                } else {
                                    break
                                }
                            }
                            
                            print("This is : \(cardNum)")
                            
                            if cardNum.count > 0 {
                                
                                for index in 0..<cardNum.count {
                                    let words = cardNum[index]
                                    self.word += words
                                }
                                
                                
                            }
                        }
                    }
                    if self.set.contains("Starbucks"){
                        print("Starbucks")
                        self.cardValue = "Starbucks"
                    }else if self.set.contains("SonusLink"){
                        print("BonusLink")
                        self.cardValue = "Bonuslink"
                    }else if self.set.contains("Golden Screen Cinemas"){
                        self.cardValue = "Golden Screen Cinemas"
                    }else{
                        self.cardValue = (" ")
                    }
                    for index in 0..<cardNum.count {
                        let words = cardNum[index]
                        self.finalValue += words
                    }
                    print(self.finalValue)
                    for label in labels {
                        
                        // if it's not the last item add a comma
                        if labels[labels.count - 1] != label {
                            labelResultsText += "\(label), "
                        } else {
                            labelResultsText += "\(label)"
                        }
                    }
                    let total = self.cardValue ?? "b"
                    let date = self.finalValue ?? "b"
                    let Inv = " " ?? "b"
//                   self.confirmInfo(total, date: date, InvNo: Inv)
                    self.confirmInfo2(total, CardNo: date, ExpDate: Inv)
                    
                } else {
                    print("No labels found")
                }
                
            }
        })
        
    }
    
    func createRequest(imageData: String) {
        // Create our request URL
        let request = NSMutableURLRequest(
            URL: NSURL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(API_KEY)")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            NSBundle.mainBundle().bundleIdentifier ?? "",
            forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest: [String: AnyObject] = [
            "requests": [
                "image": [
                    "content": imageData
                ],
                "features": [
                    [
                        "type": "TEXT_DETECTION",
                        "maxResults": 11
                    ]
                ]
            ]
        ]
        
        // Serialize the JSON
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonRequest, options: [])
        
        // Run the request on a background thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.runRequestOnBackgroundThread(request)
        });
        
    }
    
    func runRequestOnBackgroundThread(request: NSMutableURLRequest) {
        
        let session = NSURLSession.sharedSession()
        
        // run the request
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            self.analyzeResults(data!)
            
        })
        task.resume()
        
    }

    
    func confirmInfo2(MerchantName: String, CardNo: String, ExpDate: String) {
        let alert = UIAlertController(title: MerchantName, message: "Please fill in your information", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (cardOwnertextField) -> Void in
            cardOwnertextField.placeholder = "Card Owner"
        })
        
        alert.addTextFieldWithConfigurationHandler({ (cardNotextField) -> Void in
            cardNotextField.placeholder = "Card Number"
            cardNotextField.text = CardNo
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
            let cardDict = ["Card Owner":cardOwnertextField.text!,"Name":(MerchantName),"CardNo":cardNotextField.text!,"Card Expiry Date": cardExpDatetextField.text!,"Points":"1000"] as [String:AnyObject]
            cardsInfoRef.setValue(cardDict)
            self.firebaseRef.child("users").child(User.currentUserUid()!).child("UserCards").child(cardUID).setValue(true)
            self.fusumaClosed()
            self.navigationController?.popViewControllerAnimated(true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {(ACTION) -> Void in
            self.cardValue = ""
            self.finalValue = ""
            self.set.removeAll()
            
        }))
        
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
}


