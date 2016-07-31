//
//  PopOverViewController.swift
//  beepLAH
//
//  Created by JJ on 29/07/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit

class PopOverViewController: UIViewController {
    @IBOutlet var qrImage: UIImageView!
    var array = Card()
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageString = self.array.name!+"\n"+self.array.No!+"\n"+self.array.ownerName!+"\n"+self.array.point!
        let qrImage = generateQRCodeFromString(imageString)
        self.qrImage.image = qrImage
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
