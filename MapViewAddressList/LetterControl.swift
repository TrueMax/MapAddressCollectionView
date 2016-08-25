//
//  LetterControl.swift
//  MapViewAddressList
//
//  Created by Maxim on 25.08.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

@IBDesignable
class LetterControl: UIControl {
    
    @IBInspectable private var title: String {
        get {
            return self.title
        } set(newValue) {
            self.title = newValue
        }
    }
    
    @IBInspectable private var color: UIColor {
            get {
                var _color = self.backgroundColor
                _color = UIColor.blackColor()
                return _color!
        }
            set(newValue) {
                self.backgroundColor = newValue
        }
    }
    
    @IBInspectable private var image: UIImage? {
        
        didSet {
            // если image назначен (в UIControl нет image по умолчанию) 
        }
        
        
        
        
    }
    
        
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
