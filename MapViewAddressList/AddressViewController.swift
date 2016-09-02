//
//  AddressViewController.swift
//  MapViewAddressList
//
//  Created by Maxim on 24.08.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit


@objc protocol AddressViewDelegate {
    
    //Пока AnyObject а на самом деле должно быть объект типа Address
    optional func addressViewController(addressesVC: AddressViewController, didTapAddressMark address: AnyObject, AtIndex index: Int)
    optional func addressViewController(addressesVC: AddressViewController, didActivateAddress address: AnyObject, AtIndex index: Int)
    optional func addressViewController(addressesVC: AddressViewController, didAddAddress address: AnyObject, AtIndex index: Int) -> AnyObject?
    optional func addressViewController(addressesVC: AddressViewController, didRemoveAddress address: AnyObject, AtIndex index: Int)
    optional func addressViewController(addressesVC: AddressViewController, didMoveAddress address: AnyObject, fromIndex: Int, toIndex: Int)
}


class AddressViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
//override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//    
//    addressCollectionView.setNeedsLayout()
//    }
    
    @IBOutlet weak var addressCollectionView: UICollectionView!
    //@IBOutlet weak var addressCellAddingButton: UIButton
    @IBOutlet weak var verticalConstraint: NSLayoutConstraint!
    
    let addingCellsButton = UIButton(type: .ContactAdd)
    
    private var dataModel = DataModel() // источник данных для AddressViewController
    var delegate: AddressViewDelegate?
    
    private var addresses: [AnyObject] {
        get {
            return self.addresses
        }
        
        set {
            setAddresses()
        }
    }
    
    private var associatedAddress: AnyObject = "Added Address" // тут будет объект типа Address
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressCollectionView.delegate = self
        addressCollectionView.dataSource = self
        
        let height = (addressCollectionView.superview?.bounds.height)! - 43
        let width = addressCollectionView.superview?.bounds.width
        addressCollectionView.contentSize = CGSizeMake(width!, height)
        
        verticalConstraint.constant = addressCollectionView.contentSize.height
        
        let moveGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(moveCollectionViewCells(_:)))
        addressCollectionView.addGestureRecognizer(moveGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchAddress(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        addressCollectionView.addGestureRecognizer(tapGestureRecognizer)
       
        
        let oneRect = CGRectMake(0, 88, 43, 43)
        addingCellsButton.drawRect(oneRect)
        
        let superView = addressCollectionView.superview!
        superView.addSubview(addingCellsButton)
       configureAddingButton()
        
        
    }
    
    func configureAddingButton() {
        
        addingCellsButton.backgroundColor = UIColor.clearColor()
        addingCellsButton.autoresizesSubviews = true
        
        addingCellsButton.addTarget(self, action: #selector(addCellAtIndexPath(_:)), forControlEvents: .TouchUpInside)
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let addressCell = collectionView.dequeueReusableCellWithReuseIdentifier("FullCollectionViewCell", forIndexPath: indexPath) as! FullCollectionViewCell
        
        addressCell.indexPathRow = indexPath.row
        addressCell.selected = false
        // addingButtonPosition()
        
        return addressCell
        }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellWidth = collectionView.frame.size.width - 20
        let cellHeight = CGFloat(43)
        let size = CGSizeMake(cellWidth, cellHeight)
        
        return size
    }
    
    //MARK: Adding cells
    // добавляет ячейку для адреса с кнопки
    
    func addCellAtIndexPath (sender: UIButton) {
        
        if sender == addingCellsButton {
        
        if addressCollectionView.visibleCells().count == 0 {
            
            let initialIndexPath = NSIndexPath(forItem: 0, inSection: 0)
            
            dataModel.updateDataSource(initialIndexPath.row, inSection: initialIndexPath.section)
            
            UIView.animateWithDuration(1.0, delay: 0.7, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                
                self.addressCollectionView.insertItemsAtIndexPaths([initialIndexPath])
                
                }, completion: { _ in
                    let cell = self.addressCollectionView.cellForItemAtIndexPath(initialIndexPath) as! FullCollectionViewCell
                    cell.indexPathRow = initialIndexPath.row
                    
                    self.delegate?.addressViewController!(self, didAddAddress: self.associatedAddress, AtIndex: initialIndexPath.row)
                    
            })
            
        } else {
            
            if let indexPath = addressCollectionView.indexPathsForVisibleItems().last {
                
                print("DATAMODEL.COUNT: \(dataModel.dataModel.count) \n OLD INDEXPATH: \(indexPath)")
                
                let newIndexPath = dataModel.updateDataSource(indexPath.row, inSection: indexPath.section)
                
                print("NEW INDEXPATH: \(newIndexPath)")
                
                if dataModel.dataModel.count < dataModel.addressLimit {
                    
                    print("DATAMODEL COUNT: \(dataModel.dataModel.count)")
                    
                    
                    UIView.animateWithDuration(1.0, delay: 0.4, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                        
                        self.addressCollectionView.insertItemsAtIndexPaths([newIndexPath])
                        print("* ADDED CELL AT INDEXPATH, GOING INTO CALLBACK #1: \(newIndexPath)")
                        
                        }, completion: { _ in
                            let cell = self.addressCollectionView.cellForItemAtIndexPath(newIndexPath) as! FullCollectionViewCell
                            cell.indexPathRow = newIndexPath.row
                            
                            self.delegate?.addressViewController!(self, didAddAddress: self.associatedAddress, AtIndex: newIndexPath.row)
                            
                            // self.addingButtonPosition()
                    })
                    
                } else if dataModel.dataModel.count == dataModel.addressLimit {
                    
                    
                    UIView.animateWithDuration(1.0, delay: 0.4, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                        
                        self.addressCollectionView.insertItemsAtIndexPaths([newIndexPath])
                        print("** ADDED CELL AT INDEXPATH, GOING INTO CALLBACK #2: \(newIndexPath)")
                        
                        }, completion: { _ in
                            let cell = self.addressCollectionView.cellForItemAtIndexPath(indexPath) as! FullCollectionViewCell
                            cell.indexPathRow = indexPath.row
                            
                            self.delegate?.addressViewController!(self, didAddAddress: self.associatedAddress, AtIndex: newIndexPath.row)
                            
                    })
                    // addressCellAddingButton.hidden = true
                }
            }
        }
        // FIXME: добавление ячеек не меняет размер CollectionView как надо 
      //  addressCollectionView.setNeedsLayout() // не работает
        }
    }
    
    
    //MARK: Deleting cells
    // удаляет ячейку для адреса
    @IBAction func deleteCellAtIndexPath(sender: UIButton) {
        let touchPoint: CGPoint = sender.convertPoint(CGPointZero, toView: addressCollectionView)
        let touchIndexPath = addressCollectionView.indexPathForItemAtPoint(touchPoint)
        print("TouchIndexPath: \(touchIndexPath)")
        
        
        if let indexPath = touchIndexPath {
            let layout = AddressCollectionViewLayout()
            layout.disappearingItemsIndexPaths = [indexPath]
            
            dataModel.dataModel.removeAtIndex(indexPath.row)
            UIView.animateWithDuration(0.65, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                self.addressCollectionView.deleteItemsAtIndexPaths([indexPath])
            }) { (finished: Bool) -> Void in
                layout.disappearingItemsIndexPaths = nil
                // self.addingButtonPosition()
            }
            
            
        }
        // addressCellAddingButton.hidden = false
    }
    
    
    
//       delegate?.addressViewController!(self, didRemoveAddress: associatedAddress!, AtIndex: touchIndexPath!.row)
    
    
    //MARK: Moving cells
    // перемещает ячейки с адресами
        
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
        default: addressCollectionView.cancelInteractiveMovement()
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        if dataModel.dataModel.count > 1 {
            
            let firstElement = dataModel.dataModel.removeAtIndex(sourceIndexPath.row)
            dataModel.dataModel.insert(firstElement, atIndex: destinationIndexPath.row)
            
        }
//      func addressViewController(addressesVC: AddressViewController, didMoveAddress address: AnyObject, fromIndex: Int, toIndex: Int)
        }
    
    
    
    
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
//            delegate?.addressViewController!(self, didTapAddressMark: associatedAddress!, AtIndex: indexPath.row)
        }
       
        // здесь нужно передать делегату значение
        
        
      //  addressCollectionView.reloadData()
    }
    
    func searchAddress (sender: UITapGestureRecognizer) {
        
        let touchPoint = sender.locationInView(addressCollectionView)
        let touchIndexPath = addressCollectionView.indexPathForItemAtPoint(touchPoint)
        
        if let indexPath = touchIndexPath {
            
            //            delegate?.addressViewController!(self, didActivateAddress: associatedAddress!, AtIndex: indexPath.row)
            
           
                
                let cellFull = addressCollectionView.cellForItemAtIndexPath(indexPath) as! FullCollectionViewCell
                cellFull.indexPathRow = indexPath.row
            
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return dataModel.dataModel.count
    
    }
    
//    func addingButtonPosition() {
//        switch addressCollectionView.visibleCells().count {
//        case 0:
//            print("VISIBLE CELLS - 0?: \(addressCollectionView.visibleCells().count)")
//            let zeroRect = CGRectMake(0, 0, 43, 43)
//            addingCellsButton.drawRect(zeroRect)
//            addingCellsButton.setNeedsDisplay()
//        case 1:
//            print("VISIBLE CELLS - 1?: \(addressCollectionView.visibleCells().count)")
//            let oneRect = CGRectMake(0, 44, 43, 43)
//            addingCellsButton.drawRect(oneRect)
//            addingCellsButton.setNeedsDisplay()
//        case 2:
//            print("VISIBLE CELLS - 2?: \(addressCollectionView.visibleCells().count)")
//            let twoRect = CGRectMake(0, 88, 43, 43)
//            addingCellsButton.drawRect(twoRect)
//            addingCellsButton.setNeedsDisplay()
//        default:
//            print("VISIBLE CELLS DEFAULT: \(addressCollectionView.visibleCells().count)")
//            break
//        }
//    }
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: Public methods 
    
    func setAddresses() {
        
    }
    
    func setAddressAtIndex() {
        
    }
    
    func activateAddress() {
        
    }
    
    func deActivateAddress() {
        
    }

}

