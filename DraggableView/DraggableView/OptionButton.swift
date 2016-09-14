//
//  OptionButton.swift
//  DatePickerTest
//
//  Created by Ayham on 06/07/16.
//  Copyright © 2016 Taxik. All rights reserved.
//

import UIKit

@IBDesignable
class OptionButton: UIControl {
    
    @IBInspectable var title: String {
        
        get {
            
            return _title
        }
        set{
            
            _title = newValue
            setNeedsDisplay()
        }
    }

    @IBInspectable var isAcrive: Bool {
        
        get {
            
            return _isAcrive
        }
        set {
            
            _isAcrive = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var activeImage: UIImage? {
        
        get{
            
            return _activeImage
        }
        set {
            
            _activeImage = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var inactiveImage: UIImage? {
        
        get {
            
            return _inactiveImage
        }
        set{
            
            _inactiveImage = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var inactiveBoarderColor: UIColor {
        
        get {
            
            return _inactiveBoarderColor
        }
        set {
            
            _inactiveBoarderColor = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var acriveBoarderColor: UIColor {
        
        get {
            
            return _acriveBoarderColor
        }
        set {
            
            _acriveBoarderColor = newValue
            setNeedsDisplay()
        }
    }
    
    private var _title = ""
    private var _isAcrive = false
    private var _activeImage: UIImage?
    private var _inactiveImage: UIImage?
    private var _inactiveBoarderColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.300)
    private var _acriveBoarderColor = UIColor(red: 1.000, green: 0.753, blue: 0.000, alpha: 1.000)
    
    override func drawRect(rect: CGRect) {
        
        backgroundColor = UIColor.clearColor()
        drawOptionButton()
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        
        _isAcrive = !_isAcrive
        setNeedsDisplay()
    }
    
    func drawOptionButton() {
        
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let boarderColor = _isAcrive ? _acriveBoarderColor : _inactiveBoarderColor
        
        //// Border Drawing
        let borderPath = UIBezierPath(roundedRect: CGRect(x: 1, y: 1, width: 140, height: 34), cornerRadius: 3)
        boarderColor.setStroke()
        borderPath.lineWidth = 1
        borderPath.stroke()
        
        
        //// title Drawing
        let titleRect = CGRect(x: 40, y: 5, width: 98, height: 26)
        let titleTextContent = NSString(string: _title)
        let titleStyle = NSMutableParagraphStyle()
        titleStyle.alignment = .Left
        
        let titleFontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(12),
                                   NSForegroundColorAttributeName: UIColor.blackColor(),
                                   NSParagraphStyleAttributeName: titleStyle]
        
        let titleTextHeight: CGFloat = titleTextContent.boundingRectWithSize(CGSize(width: titleRect.width, height: CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: titleFontAttributes, context: nil).size.height
        CGContextSaveGState(context!)
        CGContextClipToRect(context!, titleRect)
        titleTextContent.drawInRect(CGRect(x: titleRect.minX, y: titleRect.minY + (titleRect.height - titleTextHeight) / 2, width: titleRect.width, height: titleTextHeight), withAttributes: titleFontAttributes)
        CGContextRestoreGState(context!)
        
        
        //// Rectangle Drawing
        let icon = _isAcrive ? _activeImage : _inactiveImage
        if let _ = icon {
            
            let rectanglePath = UIBezierPath(rect: CGRect(x: 10, y: 8, width: 23, height: 23))
            CGContextSaveGState(context!)
            rectanglePath.addClip()
            icon!.drawInRect(CGRect(x: 10, y: 8, width: icon!.size.width, height: icon!.size.height))
            CGContextRestoreGState(context!)
        }
    }
}
