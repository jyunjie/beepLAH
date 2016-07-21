//
//  QRCameraViewController.swift
//  beepLAH
//
//  Created by JJ on 21/07/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit
import MTBBarcodeScanner

class QRCameraViewController: UIViewController {

    var scanner: MTBBarcodeScanner!
    @IBOutlet weak var cameraScanningPreview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                        
                    }
                })
            }
        })
    }
}
