//
//  CardCollectionViewCell.swift
//  beepLAH
//
//  Created by JJ on 21/07/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet var cardMerchantName: UILabel!
    @IBOutlet var cardImage: UIImageView!
//    @IBOutlet var QRImageView: UIImageView!
    @IBOutlet weak var cardExpDate: UILabel!
    @IBOutlet var cardNumber: UILabel!
    @IBOutlet weak var cardOwner: UILabel!
}
