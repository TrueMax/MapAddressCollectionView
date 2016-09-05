//
//  AddressView.swift
//  MapViewAddressList
//
//  Created by Maxim on 02.09.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

@objc protocol AddressViewDelegate {
    
    //Пока AnyObject а на самом деле должно быть объект типа Address
    optional func addressViewController(addressView: UIView, didTapAddressMark address: AnyObject, AtIndex index: Int)
    optional func addressViewController(addressView: UIView, didActivateAddress address: AnyObject, AtIndex index: Int)
    optional func addressViewController(addressView: UIView, didAddAddress address: AnyObject, AtIndex index: Int) -> AnyObject?
    optional func addressViewController(addressView: UIView, didRemoveAddress address: AnyObject, AtIndex index: Int)
    optional func addressViewController(addressView: UIView, didMoveAddress address: AnyObject, fromIndex: Int, toIndex: Int)
}

@objc protocol AddressViewDataSource {
    
    optional func addressLimit(addressView: AddressView) -> Int
    optional func addressProvidedByMap() -> AnyObject?
    optional func defaultAddressProvidedFromSource() -> AnyObject?
}


class AddressView: UIView {
    
    private var addresses: [AnyObject]?
    
    private var _address: AnyObject?
    
    // адрес или надпись по умолчанию, отображаемые в пустой новой ячейке

    var defaultAddress: AnyObject? {
        
        return dataSource?.defaultAddressProvidedFromSource!()
    
    }
    
    // адрес, полученный от карты
    var addressProvidedByMap: AnyObject? {
        get {
        return _address
        }
        set {
            _address = dataSource?.addressProvidedByMap!()
            addresses?.append(_address!)
        }
    }
    
    var activeAddress: AnyObject?
    
    var removedAddress: AnyObject?
    
    private var _addressLimit: Int = 1
    var addressLimit: Int? {
        get {
            return _addressLimit
        }
        set {
            _addressLimit = (dataSource?.addressLimit!(self))!
            
        }
    }
    
    private var _dataSource: AddressViewDataSource?
    private var _delegate: AddressViewDelegate?
    
    var dataSource: AnyObject? {
        
        get {
            
            return _dataSource
        }
        set {
            
            _dataSource = newValue as? AddressViewDataSource
        }
    }
    
    var delegate: AnyObject? {
        
        get {
            
            return _delegate
        }
        set {
            
            _delegate = newValue as? AddressViewDelegate        }
    }

    private lazy var addressCollectionView: UICollectionView = {
        
        
        let layout = AddressCollectionViewLayout()
        let collectionView = UICollectionView(frame: self.window!.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let moveGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(moveCollectionViewCells(_:)))
        collectionView.addGestureRecognizer(moveGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didActivateAddressForSearch(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        collectionView.addGestureRecognizer(tapGestureRecognizer)
        
        return collectionView
    }()
    
    // TODO: назначить кнопке метод добавления ячеек 
    var addingButton = UIButton(type: .ContactAdd)
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.addSubview(addressCollectionView)
        
        let buttonRect = CGRectMake(0, 45, 43, 43)
        addingButton.drawRect(buttonRect)
        self.addSubview(addingButton)
        
        addingButton.addTarget(self, action: #selector(addCellAtIndexPath(_:)), forControlEvents: .TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

//MARK: CollectionView methods
extension AddressView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellWidth = collectionView.frame.size.width - 20
        let cellHeight = CGFloat(43)
        let size = CGSizeMake(cellWidth, cellHeight)
        
        return size
    }
    
    
    //MARK: CollectionViewDataSource
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellNib = UINib(nibName: "FullCollectionViewCell", bundle: NSBundle.mainBundle())
        collectionView.registerNib(cellNib, forCellWithReuseIdentifier: "FullCollectionViewCell")
        
        let addressCell = collectionView.dequeueReusableCellWithReuseIdentifier("FullCollectionViewCell", forIndexPath: indexPath) as! FullCollectionViewCell
        
        addressCell.indexPathRow = indexPath.row
        addressCell.selected = false
        // addingButtonPosition()
        
        return addressCell
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _addressLimit
    }
    
    //MARK: CollectionViewDelegate
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        if _addressLimit > 1 {
            
            
            // FIXME: этот метод сообщает делегату, что ячейка передвинулась с одного индекса на другой
            let movedAddress = addresses!.removeAtIndex(sourceIndexPath.row)
            addresses!.insert(movedAddress, atIndex: destinationIndexPath.row)
            delegate?.addressViewController!(self, didMoveAddress: movedAddress, fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
        }
        
    }
    
    func moveCollectionViewCells(gestureRecognizer: UILongPressGestureRecognizer) {
        
        switch gestureRecognizer.state {
            
        case .Began:
            guard let initialIndexPath = addressCollectionView.indexPathForItemAtPoint(gestureRecognizer.locationInView(addressCollectionView)) else {
                break
            }
            addressCollectionView.beginInteractiveMovementForItemAtIndexPath(initialIndexPath)
        case .Changed:
            addressCollectionView.updateInteractiveMovementTargetPosition(gestureRecognizer.locationInView(gestureRecognizer.view))
        case .Ended:
            addressCollectionView.endInteractiveMovement()
        default:
            addressCollectionView.cancelInteractiveMovement()
            
        }
        
    }
    
    //MARK: CollectionView actions 

    func didActivateAddressForSearch (sender: UITapGestureRecognizer) {
        
        let touchPoint = sender.locationInView(addressCollectionView)
        let touchIndexPath = addressCollectionView.indexPathForItemAtPoint(touchPoint)
        
        if let indexPath = touchIndexPath {
            
            
            let cellFull = addressCollectionView.cellForItemAtIndexPath(indexPath) as! FullCollectionViewCell
            cellFull.indexPathRow = indexPath.row
            
            activeAddress = addresses![indexPath.row]
            delegate?.addressViewController!(self, didActivateAddress: activeAddress!, AtIndex: indexPath.row)

            
            switch indexPath.row {
            case 0:
                deselectLetterButtons(cellFull)
                cellFull.selected = true
            case 1:
                deselectLetterButtons(cellFull)
                cellFull.selected = true
            case 2:
                deselectLetterButtons(cellFull)
                cellFull.selected = true
            default:
                deselectLetterButtons(cellFull)
                cellFull.selected = false
            }
            
        }
        
    }
    
    func deselectLetterButtons(fullCell: FullCollectionViewCell) {
        let visibleCells = addressCollectionView.visibleCells()
        for cell in visibleCells {
            if cell is FullCollectionViewCell {
                cell.selected = false
            }
        }
    }
    
    // TODO: назначить методу кнопку ячейки letterControlButton
    @IBAction func addressFieldMakeActive(sender: UIButton) {
        
        let touchPoint = sender.convertPoint(CGPointZero, toView: addressCollectionView)
        let touchIndexPath = addressCollectionView.indexPathForItemAtPoint(touchPoint)
        
        if let indexPath = touchIndexPath {
            let cell = addressCollectionView.cellForItemAtIndexPath(indexPath) as! FullCollectionViewCell
            
            switch indexPath.row {
            case 0, 1, 2:
                deselectLetterButtons(cell)
                cell.selected = true
                
            default:
                cell.selected = false
            }
        activeAddress = addresses![indexPath.row]
        delegate?.addressViewController!(self, didTapAddressMark: activeAddress!, AtIndex: indexPath.row)
        }
        
    }
    
    //MARK: CollectionView - add cells 
    
    // логика добавления ячейки - просто добавляется ячейка по indexPath 
    
    func addCellAtIndexPath (sender: UIButton) {
        
        if addressCollectionView.visibleCells().count == 0 {
            
            addresses = nil
            
            let initialIndexPath = NSIndexPath(forItem: 0, inSection: 0)
            
            UIView.animateWithDuration(1.0, delay: 0.7, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                
                self.addressCollectionView.insertItemsAtIndexPaths([initialIndexPath])
                
                }, completion: { _ in
                    let cell = self.addressCollectionView.cellForItemAtIndexPath(initialIndexPath) as! FullCollectionViewCell
                    cell.indexPathRow = initialIndexPath.row
                    
                    self._address = self.defaultAddress
                    self.addresses?.append(self._address!)
                    self.delegate?.addressViewController!(self, didAddAddress: self._address!, AtIndex: initialIndexPath.row)
                    
            })
            
        } else {
            
            if let indexPath = addressCollectionView.indexPathsForVisibleItems().last {
                
                let newIndexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)
                
                if addresses?.count < addressLimit {
                    
                    
                    
                    UIView.animateWithDuration(1.0, delay: 0.4, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0,options: .CurveEaseInOut, animations: { () -> Void in
                        
                        self.addressCollectionView.insertItemsAtIndexPaths([newIndexPath])
                        print("* ADDED CELL AT INDEXPATH, GOING INTO CALLBACK #1: \(newIndexPath)")
                        
                        }, completion: { _ in
                            let cell = self.addressCollectionView.cellForItemAtIndexPath(newIndexPath) as! FullCollectionViewCell
                            cell.indexPathRow = newIndexPath.row
                            
                            self.delegate?.addressViewController!(self, didAddAddress: self.addresses![indexPath.row], AtIndex: newIndexPath.row)
                            
                            // self.addingButtonPosition()
                    })
                    
                } else if addresses?.count == addressLimit {
                    
                    
                    UIView.animateWithDuration(1.0, delay: 0.4, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                        
                        self.addressCollectionView.insertItemsAtIndexPaths([newIndexPath])
                        print("** ADDED CELL AT INDEXPATH, GOING INTO CALLBACK #2: \(newIndexPath)")
                        
                        }, completion: { _ in
                            let cell = self.addressCollectionView.cellForItemAtIndexPath(indexPath) as! FullCollectionViewCell
                            cell.indexPathRow = indexPath.row
                            
                            //                            self.delegate?.addressViewController!(self, didAddAddress: self.associatedAddress, AtIndex: newIndexPath.row)
                            
                    })
                    addingButton.hidden = true
                }
            }
        }
        
    }

    
    //MARK: CollectionView - delete cells

    @IBAction func deleteCellAtIndexPath(sender: UIButton) {
        let touchPoint: CGPoint = sender.convertPoint(CGPointZero, toView: addressCollectionView)
        let touchIndexPath = addressCollectionView.indexPathForItemAtPoint(touchPoint)
        print("TouchIndexPath: \(touchIndexPath)")
        
        
        if let indexPath = touchIndexPath {
            let layout = AddressCollectionViewLayout()
            layout.disappearingItemsIndexPaths = [indexPath]
            
            addresses!.removeAtIndex(indexPath.row)
            UIView.animateWithDuration(0.65, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                self.addressCollectionView.deleteItemsAtIndexPaths([indexPath])
            }) { (finished: Bool) -> Void in
                layout.disappearingItemsIndexPaths = nil
                
                // self.addingButtonPosition()
            }
            
            
        }
        // addressCellAddingButton.hidden = false
    }

    
}
