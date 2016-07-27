//
//  AddCardTableViewCell.swift
//  beepLAH
//
//  Created by JJ on 23/07/2016.
//  Copyright © 2016 JJ. All rights reserved.
//

import UIKit

class AddCardTableViewCell: UITableViewCell {
    @IBOutlet var cardLabel: UILabel!
    
    @IBOutlet var cardImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
