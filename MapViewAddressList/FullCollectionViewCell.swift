//
//  FullCollectionViewCell.swift
//  MapViewAddressList
//
//  Created by Maxim on 24.08.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class FullCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var letterControlButton: UIButton! {
        didSet {
            if letterControlButton.selected == true {
                activeAddressColorView.backgroundColor = UIColor.yellowColor()
            } else {
                activeAddressColorView.backgroundColor = UIColor.clearColor()
            }
        }
    }
    @IBOutlet weak var addressTextLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var activeAddressColorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
