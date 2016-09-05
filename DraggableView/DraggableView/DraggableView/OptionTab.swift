//
//  OptionTab.swift
//  MaterialApp
//
//  Created by Ayham on 07/07/16.
//  Copyright © 2016 Taxik. All rights reserved.
//

import UIKit
import Material

//MARK: Enums
enum OptionTabMode: Int {
    
    case None = 0
    case Title = 1
    case Badge = 2
}

protocol OptionTabDelegate {
    
    func optionTabDidBecomeActive(optionTab: OptionTab)
    func optionTabDidBecomeInactive(optionTab: OptionTab)
}

@IBDesignable
class OptionTab: UIControl {
    
    //MARK: Inspectable properties
    @IBInspectable var tabMode: Int {
        
        get {
            
            return _tabMode.rawValue
        }
        set {
            
            if let mode = OptionTabMode(rawValue: newValue) {
                
                _tabMode = mode
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable var isActive: Bool {
        
        get {
            
            return _isActive
        }
        set {
            
            _isActive = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var title: String {
        
        get {
            
            return _title
        }
        set {
            
            _title = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var subtitle: String {
        
        get {
            
            return _subtitle
        }
        set {
            
            _subtitle = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var activeIcon: UIImage? {
        
        get {
            
            return _activeIcon
        }
        set {
            
            _activeIcon = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var inactiveIcon: UIImage? {
        
        get {
            
            return _inactiveIcon
        }
        set {
            
            _inactiveIcon = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var stripHeight: CGFloat {
        
        get {
            
            return _stripHeight
        }
        set {
            
            _stripHeight = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var dividerWidth: CGFloat {
        
        get {
            
            return _dividerWidth
        }
        set {
            
            _dividerWidth = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var stripColor: UIColor {
        
        get {
            
            return _stripColor
        }
        set {
            
            _stripColor = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var titleColor: UIColor {
        
        get {
            
            return _titleColor
        }
        set {
            
            _titleColor = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var subtitleColor: UIColor {
        
        get {
            
            return _subtitleColor
        }
        set {
            
            _subtitleColor = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var badgeValue: Int {
        
        get {
            
            if _badgeValue.characters.count > 0 {
                
                return Int(_badgeValue)!
            }
            
            return 0
        }
        set {
            
            if newValue > 0 {
                
                _badgeValue = "\(newValue)"
            }
            else {
                
                _badgeValue = ""
            }
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var badgeColor: UIColor {
        
        get {
            
            return _badgeColor
        }
        set{
            
            _badgeColor = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var dividerColor: UIColor {
        
        get {
            
            return _dividerColor
        }
        set {
            
            _dividerColor = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var inactiveTitleColor: UIColor? {
        
        get {
            
            return _inactiveTitleColor
        }
        set {
            
            _inactiveTitleColor = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var inactiveSubtitleColor: UIColor? {
        
        get {
            
            return _inactiveSubtitleColor
        }
        set {
            
            _inactiveSubtitleColor = newValue
            setNeedsDisplay()
        }
    }
    
    //MARK: Overrides properties
    override var frame: CGRect {
        
        didSet{
            
            setNeedsDisplay()
        }
    }
    
    //MARK: Readonly properties
    var mode: OptionTabMode {
        
        return _tabMode
    }
    
    //MARK: Public prooerties
    var delegate: OptionTabDelegate?
    
    //MARK: Private properties
    private var _isActive = false
    private var _title: String = ""
    private var _subtitle: String = ""
    private var _badgeValue: String = ""
    private var _activeIcon: UIImage?
    private var _inactiveIcon: UIImage?
    private var _stripHeight: CGFloat = 2
    private var _dividerWidth: CGFloat = 1
    private var _tabMode: OptionTabMode = .Title
    private var _stripColor: UIColor = UIColor(red: 1.000, green: 0.773, blue: 0.145, alpha: 1.000)
    private var _titleColor: UIColor = UIColor(red: 0.447, green: 0.447, blue: 0.447, alpha: 1.000)
    private var _subtitleColor: UIColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
    private var _badgeColor: UIColor = UIColor(red: 1.000, green: 0.773, blue: 0.145, alpha: 1.000)
    private var _dividerColor: UIColor = UIColor(red: 0.447, green: 0.447, blue: 0.447, alpha: 1.000)
    
    private var _inactiveTitleColor: UIColor?
    private var _inactiveSubtitleColor: UIColor?
    
    init(frame: CGRect, mode: OptionTabMode) {
        
        super.init(frame: frame)
        _tabMode = mode
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

    //MARK: Drawing
    override func drawRect(rect: CGRect) {
        
        let icon = _isActive ? _activeIcon : _inactiveIcon
        if let _ = icon {
            
            switch _tabMode {
            case .None:
                badgeValue = 0
                drawOptionsBarTabWithBadge(bounds, icon: icon!)
            case .Title:
                drawOptionsBarTabWithTitle(bounds, icon: icon!)
            case .Badge:
                drawOptionsBarTabWithBadge(bounds, icon: icon!)
            }
        }
    }
    
    //MARK: Events
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        
        if _isActive {
            
            delegate?.optionTabDidBecomeInactive(self)
        }
        else {
            
            delegate?.optionTabDidBecomeActive(self)
        }
        _isActive = !_isActive
        setNeedsDisplay()
    }
    
    //MARK: Privates methods
    private func drawOptionsBarTabWithTitle(bounds: CGRect, icon: UIImage) {
        
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Variable Declarations
        let iconHolderWidth: CGFloat = icon.size.width
        let iconHolderHeight: CGFloat = icon.size.height
        let iconHolderOffsetX: CGFloat = abs(21 - iconHolderWidth) / 2
        
        //// strip Drawing
        if isActive {
            
            let stripPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: bounds.width, height: stripHeight))
            stripColor.setFill()
            stripPath.fill()
        }
        
        
        //// divider Drawing
        let dividerFrame = CGRect(x: bounds.width - dividerWidth, y: 0, width: dividerWidth, height: bounds.height)
        let dividerPath = UIBezierPath(rect: dividerFrame)
        dividerColor.setFill()
        dividerPath.fill()
        
        //// iconHolder Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, bounds.minX + 0.50375 * bounds.width, bounds.minY + 0.30312 * bounds.height)
        
        let iconHolderRect = CGRect(x: -16.1 - iconHolderOffsetX,
                                    y: -12.0,
                                    width: (iconHolderWidth + 9.20187793427),
                                    height: (iconHolderHeight + 8.5))
        let iconHolderPath = UIBezierPath(rect: iconHolderRect)
        CGContextSaveGState(context)
        iconHolderPath.addClip()
        let iconFrame = CGRect(x: floor(iconHolderRect.minX + 5 + 0.5),
                               y: floor(iconHolderRect.minY + 5 + 0.5),
                               width: icon.size.width,
                               height: icon.size.height)
        icon.drawInRect(iconFrame)
        CGContextRestoreGState(context)
        
        CGContextRestoreGState(context)
        
        //// title Drawing
        let titleRect = CGRect(x: bounds.minX + floor(bounds.width * 0.02917 + 0.5),
                               y: bounds.minY + floor(bounds.height * 0.52250 + 0.5),
                               width: floor(bounds.width * 0.96667 + 0.5) - floor(bounds.width * 0.02917 + 0.5),
                               height: floor(bounds.height * 0.95000 + 0.5) - floor(bounds.height * 0.56250 + 0.5))
        let titleStyle = NSMutableParagraphStyle()
        titleStyle.alignment = .Center
        
        let titleColorLoacl = _isActive ? titleColor : inactiveTitleColor ?? titleColor
        let titleFontAttributes = [NSFontAttributeName: RobotoFont.regularWithSize(14),
                                   NSForegroundColorAttributeName: titleColorLoacl,
                                   NSParagraphStyleAttributeName: titleStyle]
        
        NSString(string: title).drawInRect(titleRect, withAttributes: titleFontAttributes)
        
        
        //// subtitle Drawing
        let subtitleRect = CGRect(x: bounds.minX + floor(bounds.width * 0.03333 + 0.5),
                                  y: bounds.minY + floor(bounds.height * 0.74750 + 0.5),
                                  width: floor(bounds.width * 0.97083 + 0.5) - floor(bounds.width * 0.03333 + 0.5),
                                  height: floor(bounds.height * 0.97500 + 0.5) - floor(bounds.height * 0.78750 + 0.5))
        let subtitleStyle = NSMutableParagraphStyle()
        subtitleStyle.alignment = .Center
        
        let subtitleColorLoacl = _isActive ? subtitleColor : inactiveSubtitleColor ?? subtitleColor
        let subtitleFontAttributes = [NSFontAttributeName: RobotoFont.regularWithSize(14),
                                      NSForegroundColorAttributeName: subtitleColorLoacl,
                                      NSParagraphStyleAttributeName: subtitleStyle]
        
        let subtitleTextHeight: CGFloat = NSString(string: subtitle).boundingRectWithSize(CGSize(width: subtitleRect.width, height: CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: subtitleFontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, subtitleRect)
        let subtitleFrame = CGRect(x: subtitleRect.minX,
                                   y: subtitleRect.minY + (subtitleRect.height - subtitleTextHeight) / 2,
                                   width: subtitleRect.width,
                                   height: subtitleTextHeight)
        NSString(string: subtitle).drawInRect(subtitleFrame, withAttributes: subtitleFontAttributes)
        CGContextRestoreGState(context)
    }
    
    private func drawOptionsBarTabWithBadge(bounds: CGRect, icon: UIImage) {
        
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let badgeTextColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        //// Variable Declarations
        let iconHolderWidth: CGFloat = 21
        let iconHolderHeight: CGFloat = 21
        let iconHolderOffsetX: CGFloat = abs(21 - iconHolderWidth) / 2
        
        //// strip Drawing
        if isActive {
            
            let stripPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: bounds.width, height: stripHeight))
            stripColor.setFill()
            stripPath.fill()
        }
        
        
        //// divider Drawing
        let dividerFrame = CGRect(x: bounds.width - dividerWidth, y: 0, width: dividerWidth, height: bounds.height)
        let dividerPath = UIBezierPath(rect: dividerFrame)
        dividerColor.setFill()
        dividerPath.fill()
        
        //// iconHolder Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, bounds.minX + 0.50375 * bounds.width, bounds.minY + 0.30312 * bounds.height)
        
        let iconHolderRect = CGRect(x: -16.1 - iconHolderOffsetX,
                                    y: -12.0,
                                    width: (iconHolderWidth + 9.20187793427),
                                    height: (iconHolderHeight + 8.5))
        let iconHolderPath = UIBezierPath(rect: iconHolderRect)
        CGContextSaveGState(context)
        iconHolderPath.addClip()
        let iconFrame = CGRect(x: floor(iconHolderRect.minX + 5 + 0.5),
                               y: floor(iconHolderRect.minY + 5 + 0.5),
                               width: icon.size.width,
                               height: icon.size.height)
        icon.drawInRect(iconFrame)
        CGContextRestoreGState(context)
        
        CGContextRestoreGState(context)
        
        //// title Drawing
        let titleRect = CGRect(x: bounds.minX + floor(bounds.width * 0.02917 + 0.5),
                               y: bounds.minY + floor(bounds.height * 0.49250 + 0.5),
                               width: floor(bounds.width * 0.96667 + 0.5) - floor(bounds.width * 0.02917 + 0.5),
                               height: floor(bounds.height * 0.95000 + 0.5) - floor(bounds.height * 0.56250 + 0.5))
        let titleStyle = NSMutableParagraphStyle()
        titleStyle.alignment = .Center
        
        let titleColorLoacl = _isActive ? titleColor : inactiveTitleColor ?? titleColor
        let titleFontAttributes = [NSFontAttributeName: RobotoFont.regularWithSize(14),
                                   NSForegroundColorAttributeName: titleColorLoacl,
                                   NSParagraphStyleAttributeName: titleStyle]
        
        NSString(string: title).drawInRect(titleRect, withAttributes: titleFontAttributes)
        
        //// badge Drawing
        if badgeValue > 0 {
            
            let badgeRect = CGRect(x: bounds.minX + floor((bounds.width - 16) * 0.50000 + 0.5),
                                   y: bounds.minY + floor((bounds.height - 15) * 0.92754 + 0.5),
                                   width: 16,
                                   height: 15)
            let badgePath = UIBezierPath(roundedRect: badgeRect, cornerRadius: 1)
            badgeColor.setFill()
            badgePath.fill()
            let badgeStyle = NSMutableParagraphStyle()
            badgeStyle.alignment = .Center
            
            let badgeFontAttributes = [NSFontAttributeName: RobotoFont.regularWithSize(11),
                                       NSForegroundColorAttributeName: badgeTextColor,
                                       NSParagraphStyleAttributeName: badgeStyle]
            
            let badgeTextHeight: CGFloat = NSString(string: _badgeValue).boundingRectWithSize(CGSize(width: badgeRect.width, height: CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: badgeFontAttributes, context: nil).size.height
            CGContextSaveGState(context)
            CGContextClipToRect(context, badgeRect)
            NSString(string: _badgeValue).drawInRect(CGRect(x: badgeRect.minX, y: badgeRect.minY + (badgeRect.height - badgeTextHeight) / 2, width: badgeRect.width, height: badgeTextHeight), withAttributes: badgeFontAttributes)
            CGContextRestoreGState(context)
        }
    }
}
