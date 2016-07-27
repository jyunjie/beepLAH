//
//  QRCameraViewController.swift
//  beepLAH
//
//  Created by JJ on 21/07/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import MTBBarcodeScanner
import Firebase
import AVFoundation

class QRCameraViewController: UIViewController {
    var audioPlayer: AVAudioPlayer!
    var scanner: MTBBarcodeScanner!
    let firebaseRef = FIRDatabase.database().reference()
    @IBOutlet weak var cameraScanningPreview: UIView!
    
    override func viewDidLoad() {
        playVes()
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.title = "QR Scan"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        scanner = MTBBarcodeScanner(previewView: self.cameraScanningPreview)
        
        
        barcodeScanner()
    }
    
    func barcodeScanner() {
        MTBBarcodeScanner.requestCameraPermissionWithSuccess({ (success) in
            if success {
                self.scanner.startScanningWithResultBlock({ (codes) in
                    if let code: AVMetadataMachineReadableCodeObject = codes.first as? AVMetadataMachineReadableCodeObject {
                        print(code.type)
                        print(code.stringValue)
                        self.playVes()
                        if code.stringValue == "Starbucks 100 points" {
                            let alertController = UIAlertController(title: "Thank you for visiting Starbucks", message: "Additional points had been accredited", preferredStyle: .Alert)
                            
                            let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
                                
                            }
                            alertController.addAction(okAction)
                            
                            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                                
                            }
                            alertController.addAction(cancelAction)
                            
                            self.presentViewController(alertController, animated: true) {
                                
                            }
                        }else if code.stringValue == "Starbucks promo" {
                            let alertController = UIAlertController(title: "Welcome to Starbucks", message: "You are entitled for this promotion", preferredStyle: .Alert)
                            
                            let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
                                self.performSegueWithIdentifier("PromoSegue", sender: nil)
                            }
                            alertController.addAction(okAction)
                            
                            self.presentViewController(alertController, animated: true) {
                                
                            }
                        }
                    }
                    
                })
            }
        })
    }
    
    func playVes() {
        do {
            self.audioPlayer =  try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Beep", ofType: "wav")!))
            self.audioPlayer.play()
            
        } catch {
            print("Error")
        }
    }
}

