//
//  FullCollectionViewCell.swift
//  MapViewAddressList
//
//  Created by Maxim on 24.08.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

enum ButtonImageLetter: String {
        case Null = "A"
        case One = "B"
        case Two = "C"
        case Three = "D"
        case Four = "E"
        case Five = "F"
        case Six = "G"
}

class FullCollectionViewCell: UICollectionViewCell {
    
    static let lineColor = UIColor(red: 255/255, green: 192/255, blue: 0/255, alpha: 1)

    private var initialLetter: String?
    
    var indexPathRow: Int? {
        didSet {
            if let _indexPathRow = indexPathRow {
                print("IndexPathRow for cell: \(_indexPathRow)")
            initialLetter = setLetterImagesForLetterControlButton(_indexPathRow)
            }
        }
    }
    
    var activeImageName: String {
        return "\(initialLetter!)_activeaddress"
    }
    var inactiveImageName: String {
        return "\(initialLetter!)_inactiveaddress"
    }
    
    override var selected: Bool {
        
        didSet {
            // для выбранной ячейки картинка кнопки соответствует "БУКВА" = indexPath.row + activeaddress
            if selected {
                
                letterControlButton.selected = true
                letterControlButton.setBackgroundImage(UIImage(named: activeImageName), forState: .Selected)
                print("ACTIVE: \(activeImageName)")
                addressTextLabel.text = "Address SELECTED"
                activeAddressColorView.backgroundColor = FullCollectionViewCell.lineColor
               
                // для неактивной ячейки картинка кнопки соответствует "БУКВА" = indexPath.row + inactiveaddress
            } else if !selected {
            
                letterControlButton.selected = false
                letterControlButton.setBackgroundImage(UIImage(named: inactiveImageName), forState: .Normal)
                print("INACTIVE: \(inactiveImageName)")
                addressTextLabel.text = "Address not selected"
                activeAddressColorView.backgroundColor = .clearColor()
                
            }
        }
    }
    
    @IBOutlet weak var letterControlButton: UIButton!
    @IBOutlet weak var addressTextLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var activeAddressColorView: UIView!

    
    private func setLetterImagesForLetterControlButton(indexPathRow: Int) -> String {
        print("IndexPathRow sent to cell: \(indexPathRow)")
        switch indexPathRow {
        case 0:
            return ButtonImageLetter.Null.rawValue
        case 1:
            return ButtonImageLetter.One.rawValue
        case 2:
            return ButtonImageLetter.Two.rawValue
        case 3:
            return ButtonImageLetter.Three.rawValue
        case 4:
            return ButtonImageLetter.Four.rawValue
        case 5:
            return ButtonImageLetter.Five.rawValue
        case 6:
            return ButtonImageLetter.Six.rawValue
        default:
            break
        }
        return "A"
    }
}
