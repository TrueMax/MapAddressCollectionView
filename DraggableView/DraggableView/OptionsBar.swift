//
//  OptionsBar.swift
//  MaterialApp
//
//  Created by Ayham on 07/07/16.
//  Copyright © 2016 Taxik. All rights reserved.
//

import UIKit

//MARK: Protocols
@objc protocol OptionsBarDataSource {
    
    func countOfTabsInOptionsBar() -> Int
    func optionsBar(optionsBar: OptionsBar, weightForTabAtIndx index: Int) -> CGFloat
    func optionsBar(optionsBar: OptionsBar, modeForTabAtIndx index: Int) -> Int
    
    func optionsBar(optionsBar: OptionsBar, titleForTabAtIndx index: Int) -> String
    func optionsBar(optionsBar: OptionsBar, subtitleForTabAtIndx index: Int) -> String
    func optionsBar(optionsBar: OptionsBar, activeIconForTabAtIndx index: Int) -> UIImage
    func optionsBar(optionsBar: OptionsBar, inactiveIconForTabAtIndx index: Int) -> UIImage
    
    optional func optionsBar(optionsBar: OptionsBar, activeTitleColorForTabAtIndx index: Int) -> UIColor
    optional func optionsBar(optionsBar: OptionsBar, activeSubtitleColorForTabAtIndx index: Int) -> UIColor
    optional func optionsBar(optionsBar: OptionsBar, inactiveTitleColorForTabAtIndx index: Int) -> UIColor
    optional func optionsBar(optionsBar: OptionsBar, inactiveSubtitleColorForTabAtIndx index: Int) -> UIColor
}

@objc protocol OptionsBarDelegate {
    
    func optionsBar(optionsBar: OptionsBar, willDisplayTab tab: OptionTab, AtIndx index: Int)
    func optionsBar(optionsBar: OptionsBar, didActiveTabAtIndx index: Int)
    func optionsBar(optionsBar: OptionsBar, didDeactivateTabAtIndx index: Int)
    
    optional func optionsBar(optionsBar: OptionsBar, stripHeightForTabAtIndex index: Int) -> CGFloat
    optional func optionsBar(optionsBar: OptionsBar, dividerWidthForTabAtIndex index: Int) -> CGFloat
    optional func optionsBar(optionsBar: OptionsBar, stripColorForTabAtIndex index: Int) -> UIColor
    optional func optionsBar(optionsBar: OptionsBar, dividerColorForTabAtIndex index: Int) -> UIColor
}

@IBDesignable
class OptionsBar: UIView {
    
    //MARK: Private properties
    private var _dataSource: OptionsBarDataSource?
    private var _delegate: OptionsBarDelegate?
    private var tabs = [OptionTab]()
    private var tabsFrames = [CGRect]()
    
    //MARK: Outlet properties
    @IBOutlet var dataSource: AnyObject? {
        get {
            
            return _dataSource
        }
        set {
            
            _dataSource = newValue as? OptionsBarDataSource
        }
    }
    
    @IBOutlet var delegate: AnyObject? {
        get {
            
            return _delegate
        }
        set {
            
            _delegate = newValue as? OptionsBarDelegate
        }
    }
    
    //MARK: Inits
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OptionsBar.orientationDidChange), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OptionsBar.orientationDidChange), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    //MARK: Drawing
    override func drawRect(rect: CGRect) {
        
        reloadData()
    }
    
    //MARK: Public methods
    func reloadData() {
        
        let tabsCount = dataSource?.countOfTabsInOptionsBar() ?? 0
        if tabsCount == tabs.count {
            
            updateTaps(frame)
        }
        else {
            
            clearTabs()
            initTabs(frame, tabsCount: tabsCount)
        }
    }

    func updateBadgeValue(value: Int, forTabAtIndex index: Int) {
        
        let tab = tabs[index]
        if tab.mode == .Badge {
            
            tab.badgeValue = value
        }
    }
    
    //MARK: Private methods
    @objc private func orientationDidChange() {
        
        setNeedsDisplay()
    }
    
    private func clearTabs() {
        
        for tab in tabs {
            
            tab.removeFromSuperview()
        }
        tabs.removeAll()
    }
    
    private func updateTaps(frame: CGRect) {
        
        initFrames(tabs.count, frame: frame)
        
        for index in 0..<tabs.count {
            
            let mode = dataSource?.optionsBar(self, modeForTabAtIndx: index) ?? 0
            let tab = tabs[index]
            
            let defaultColor = UIColor.blackColor()
            
            tab.tabMode = mode
            tab.frame = tabsFrames[index]
            tab.title = dataSource?.optionsBar(self, titleForTabAtIndx: index) ?? ""
            tab.subtitle = dataSource?.optionsBar(self, subtitleForTabAtIndx: index) ?? ""
            tab.activeIcon = dataSource?.optionsBar(self, activeIconForTabAtIndx: index) ?? nil
            tab.inactiveIcon = dataSource?.optionsBar(self, inactiveIconForTabAtIndx: index) ?? nil
            tab.titleColor = dataSource?.optionsBar?(self, activeTitleColorForTabAtIndx: index) ?? defaultColor
            tab.subtitleColor = dataSource?.optionsBar?(self, activeSubtitleColorForTabAtIndx: index) ?? defaultColor
            tab.inactiveTitleColor = dataSource?.optionsBar?(self, inactiveTitleColorForTabAtIndx: index) ?? defaultColor
            tab.inactiveSubtitleColor = dataSource?.optionsBar?(self, inactiveSubtitleColorForTabAtIndx: index) ?? defaultColor
            
            tab.stripHeight = delegate?.optionsBar?(self, stripHeightForTabAtIndex: index) ?? 2.0
            tab.dividerWidth = delegate?.optionsBar?(self, dividerWidthForTabAtIndex: index) ?? 1.0
            tab.stripColor = delegate?.optionsBar?(self, stripColorForTabAtIndex: index) ?? UIColor.blackColor()
            tab.dividerColor = delegate?.optionsBar?(self, dividerColorForTabAtIndex: index) ?? UIColor.blackColor()
        }
    }
    
    private func initTabs(frame: CGRect, tabsCount: Int) {
        
        initFrames(tabsCount, frame: frame)
        
        for index in 0..<tabsCount {
        
            let mode = dataSource?.optionsBar(self, modeForTabAtIndx: index) ?? 0
            let tabMode = OptionTabMode(rawValue: mode) ?? .None
            
            let frame = tabsFrames[index]
            let defaultColor = UIColor.blackColor()
            
            let tab = OptionTab(frame: frame, mode: tabMode)
            
            tab.title = dataSource?.optionsBar(self, titleForTabAtIndx: index) ?? ""
            tab.subtitle = dataSource?.optionsBar(self, subtitleForTabAtIndx: index) ?? ""
            tab.activeIcon = dataSource?.optionsBar(self, activeIconForTabAtIndx: index) ?? nil
            tab.inactiveIcon = dataSource?.optionsBar(self, inactiveIconForTabAtIndx: index) ?? nil
            tab.titleColor = dataSource?.optionsBar?(self, activeTitleColorForTabAtIndx: index) ?? defaultColor
            tab.subtitleColor = dataSource?.optionsBar?(self, activeSubtitleColorForTabAtIndx: index) ?? defaultColor
            tab.inactiveTitleColor = dataSource?.optionsBar?(self, inactiveTitleColorForTabAtIndx: index) ?? defaultColor
            tab.inactiveSubtitleColor = dataSource?.optionsBar?(self, inactiveSubtitleColorForTabAtIndx: index) ?? defaultColor
            
            tab.stripHeight = delegate?.optionsBar?(self, stripHeightForTabAtIndex: index) ?? 2.0
            tab.dividerWidth = delegate?.optionsBar?(self, dividerWidthForTabAtIndex: index) ?? 1.0
            tab.stripColor = delegate?.optionsBar?(self, stripColorForTabAtIndex: index) ?? UIColor.blackColor()
            tab.dividerColor = delegate?.optionsBar?(self, dividerColorForTabAtIndex: index) ?? UIColor.blackColor()
            
            tab.delegate = self
            tab.backgroundColor = UIColor.clearColor()
    
            tabs.append(tab)
            
            delegate?.optionsBar(self, willDisplayTab: tab, AtIndx: index)
            addSubview(tab)
        }
        
        tabs.last?.dividerWidth = 0
    }
    
    private func initFrames(tabsCount: Int, frame: CGRect) {
        
        let defaultTabWidth = frame.width / CGFloat(tabsCount)
        
        var widths = [CGFloat]()
        var widthsSum: CGFloat = 0.0
        
        for index in 0..<tabsCount {
        
            let tabWeight: CGFloat = dataSource?.optionsBar(self, weightForTabAtIndx: index) ?? 1.0
            let neededTabWidth = defaultTabWidth * tabWeight
    
            widthsSum += neededTabWidth
            widths.append(neededTabWidth)
        }
        
        tabsFrames.removeAll()
        let difference: CGFloat = (frame.width - widthsSum) / CGFloat(tabsCount)
        var tabX: CGFloat = 0.0
        
        for index in 0..<tabsCount {
        
            var neededFrame = CGRect.zero
            
            widths[index] += difference
            
            neededFrame.origin.y = 0
            neededFrame.size.width = widths[index]
            neededFrame.size.height = frame.size.height
            neededFrame.origin.x = tabX
            
            tabX += widths[index]
            
            tabsFrames.append(neededFrame)
        }
    }
}

//MARK: Option tab delegate
extension OptionsBar: OptionTabDelegate {
    
    func optionTabDidBecomeActive(optionTab: OptionTab) {
        
        if let index = tabs.indexOf(optionTab) {
            
            tabs.forEach{
                
                if $0.isActive {
                    
                    $0.isActive = false
                    delegate?.optionsBar(self, didDeactivateTabAtIndx: tabs.indexOf($0)!)
                }
            }
            
            delegate?.optionsBar(self, didActiveTabAtIndx: index)
        }
    }
    
    func optionTabDidBecomeInactive(optionTab: OptionTab) {
        
        if let index = tabs.indexOf(optionTab) {
            
            delegate?.optionsBar(self, didDeactivateTabAtIndx: index)
        }
    }
}

