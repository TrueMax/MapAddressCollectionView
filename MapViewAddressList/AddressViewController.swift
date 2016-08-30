//
//  AddressViewController.swift
//  MapViewAddressList
//
//  Created by Maxim on 24.08.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit
import MapKit

@objc protocol AddressViewDelegate {
    
        optional func addressDidTapped() // пользователь нажал ячейку с адресом - перевел надувной шарик в активное состояние
        optional func addressSearchDidActivated(indexPath: NSIndexPath) // нажатие средней кнопки / label активирует алгоритм выбора адреса (поиск, favorites, адрес из списка, ввод с клавиатуры)
        optional func addressDidDeleted(indexPath: NSIndexPath)// адресная ячейка удалена из AddressView
        optional func addressDidMoved(from indexPath: NSIndexPath, toIndexPath: NSIndexPath)
}

@objc protocol AddessViewDelegateAyham {
    
    //Пока AnyObject а на самом деле должно быть объект типа Address
    optional func addressViewController(addressesVC: AddressViewController, didTabAddress address: AnyObject, AtIndex index: Int)
    optional func addressViewController(addressesVC: AddressViewController, didActiveAddress address: AnyObject, AtIndex index: Int)
    optional func addressViewController(addressesVC: AddressViewController, didDeactiveAddress address: AnyObject, AtIndex index: Int)
    optional func addressViewController(addressesVC: AddressViewController, didAddAddress address: AnyObject, AtIndex index: Int) -> AnyObject
    optional func addressViewController(addressesVC: AddressViewController, didRemoveAddress address: AnyObject, AtIndex index: Int)
    optional func addressViewController(addressesVC: AddressViewController, didMoveAddress address: AnyObject, fromIndex: Int, toIndex: Int)
}


class AddressViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
//    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//        addressCollectionView.setNeedsLayout()
//    }
    
    @IBOutlet weak var addressCollectionView: UICollectionView!
    
    private var dataModel = DataModel() // источник данных для AddressViewController
    var delegate: AddressViewDelegate?
    private var current_count = 0
    private var previous_count = 0
    private var addresses: [AnyObject] {
        get {
            return self.addresses
        }
        
        set {
            setAddresses()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressCollectionView.delegate = self
        addressCollectionView.dataSource = self
        
        let moveGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(moveCollectionViewCells(_:)))
        addressCollectionView.addGestureRecognizer(moveGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchAddress(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        addressCollectionView.addGestureRecognizer(tapGestureRecognizer)
        
       // addressCollectionView.translatesAutoresizingMaskIntoConstraints = true
        
        current_count = dataModel.dataModel.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellFull = collectionView.dequeueReusableCellWithReuseIdentifier("FullCollectionViewCell", forIndexPath: indexPath) as! FullCollectionViewCell
        
        let cellEmpty = collectionView.dequeueReusableCellWithReuseIdentifier("EmptyCollectionViewCell", forIndexPath: indexPath) as! EmptyCollectionViewCell
        
        
        switch (indexPath.row) {
        case 0:
            if current_count < 2 {
            cellFull.deleteButton.enabled = false
            cellFull.letterControlButton.setBackgroundImage(UIImage(named: "A_inactiveaddress"), forState: .Normal)
            cellFull.letterControlButton.setBackgroundImage(UIImage(named: "A_activeaddress"), forState: .Selected)
            return cellFull
            
            } else {
                return cellFull
            }
        case 1:
            if current_count == 2 {
            cellFull.letterControlButton.setBackgroundImage(UIImage(named: "B_inactiveaddress"), forState: .Normal)
            cellFull.letterControlButton.setBackgroundImage(UIImage(named: "B_activeaddress"), forState: .Selected)
                return cellFull
            } else {
            return cellEmpty
            }
        case 2:
            if current_count == 3 {
            cellFull.letterControlButton.setBackgroundImage(UIImage(named: "C_inactiveaddress"), forState: .Normal)
            cellFull.letterControlButton.setBackgroundImage(UIImage(named: "C_activeaddress"), forState: .Selected)
                return cellFull
            } else {
                return cellEmpty
            }
        default:
            return cellEmpty
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width - 20
        let cellHeight = CGFloat(40)
        let size = CGSizeMake(cellWidth, cellHeight)
        return size
    }
    
    //MARK: Adding cells
    // добавляет ячейку Full для адреса
    @IBAction func addCellAtIndexPath (sender: UIButton) {
        
        dataModel.updateDataModel("Address")
        current_count = current_count + 1
        
        let touchPoint: CGPoint = sender.convertPoint(CGPointZero, toView: addressCollectionView)
        let touchIndexPath = addressCollectionView.indexPathForItemAtPoint(touchPoint)
        print("TouchIndexPath: \(touchIndexPath)")
        
        if current_count < dataModel.addressLimit {
            
            print("PREVIOUS COUNT: \(previous_count), CURRENT COUNT: \(current_count)")
            
            let indexPath = touchIndexPath
            previous_count = previous_count + 1
            print("PREVIOUS COUNT: \(previous_count), CURRENT COUNT: \(current_count)")
            UIView.animateWithDuration(1.0, delay: 0.4, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                
                self.addressCollectionView.insertItemsAtIndexPaths([indexPath!])
                
                // FIXME: completion почему-то не работает, надо разбираться, почему
                }, completion: { _ in
                    
                    let firstCellIndexPath = self.addressCollectionView.indexPathsForVisibleItems().first
                    if let _indexPath = firstCellIndexPath {
                        
                        let cell = self.addressCollectionView.cellForItemAtIndexPath(_indexPath) as! FullCollectionViewCell
                        cell.deleteButton.enabled = true
                        
                        
                    }
            })
                    
        } else if current_count == dataModel.addressLimit {
            previous_count = previous_count + 1
            print("PREVIOUS COUNT: \(previous_count), CURRENT COUNT: \(current_count)")
            let indexPath = touchIndexPath
            addressCollectionView.reloadItemsAtIndexPaths([indexPath!])
        }
       // addressCollectionView.reloadData()
    }
    
    //MARK: Deleting cells
    // удаляет ячейку для адреса
    @IBAction func deleteCellAtIndexPath(sender: UIButton) {
        let touchPoint: CGPoint = sender.convertPoint(CGPointZero, toView: addressCollectionView)
        let touchIndexPath = addressCollectionView.indexPathForItemAtPoint(touchPoint)
        print("TouchIndexPath: \(touchIndexPath)")
        
        
        if let indexPath = touchIndexPath {
            if current_count == dataModel.addressLimit {
                
                previous_count = current_count
                current_count = current_count - 1
                
                let layout = AddressCollectionViewLayout()
                layout.disappearingItemsIndexPaths = [indexPath]
                dataModel.dataModel.removeAtIndex(indexPath.row)
                
                addressCollectionView.reloadItemsAtIndexPaths([indexPath])
                print("PREVIOUS COUNT: \(previous_count), CURRENT COUNT: \(current_count)")
                
                 } else {
                
                previous_count = current_count
                current_count = current_count - 1
                
                let layout = AddressCollectionViewLayout()
                layout.disappearingItemsIndexPaths = [indexPath]
                dataModel.dataModel.removeAtIndex(indexPath.row)
                
                UIView.animateWithDuration(0.65, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.addressCollectionView.deleteItemsAtIndexPaths([indexPath])
                }) { (finished: Bool) -> Void in
                    layout.disappearingItemsIndexPaths = nil
                }
            }
            
        }
       // addressCollectionView.reloadData()
    }
    
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
        
      //  addressCollectionView.reloadData()
    }
    
    
    
    @IBAction func addressFieldMakeActive(sender: UIButton) {
        
        let touchPoint = sender.convertPoint(CGPointZero, toView: addressCollectionView)
        let touchIndexPath = addressCollectionView.indexPathForItemAtPoint(touchPoint)
        
        if let indexPath = touchIndexPath {
            sender.tag = indexPath.item
        
            switch indexPath.row {
            case 0, 1, 2:
                sender.selected = true
            
            default:
                if sender.state == .Selected {
                    sender.selected = false
                }
            }
        }
       
        // здесь нужно передать делегату значение
        delegate?.addressDidTapped!()
        
      //  addressCollectionView.reloadData()
    }
    
    func searchAddress (sender: UITapGestureRecognizer) {
        
        let touchPoint = sender.locationInView(addressCollectionView)
        let touchIndexPath = addressCollectionView.indexPathForItemAtPoint(touchPoint)
        
        if let indexPath = touchIndexPath {
            
            delegate?.addressSearchDidActivated?(indexPath)
            
            if addressCollectionView.cellForItemAtIndexPath(indexPath) is EmptyCollectionViewCell {
                
                sender.cancelsTouchesInView = true
            
            } else {
                
                let cellFull = addressCollectionView.cellForItemAtIndexPath(indexPath) as! FullCollectionViewCell
                
                let lineColor = UIColor(red: 255/255, green: 192/255, blue: 0/255, alpha: 1)
                
                switch indexPath.row {
                case 0:
                    cellFull.activeAddressColorView.backgroundColor = lineColor
                    cellFull.letterControlButton.selected = true
                    cellFull.addressTextLabel.text = "A ADDRESS ACTIVE"
                case 1:
                    cellFull.activeAddressColorView.backgroundColor = lineColor
                    cellFull.letterControlButton.selected = true
                    cellFull.addressTextLabel.text = "B ADDRESS ACTIVE"
                case 2:
                    cellFull.activeAddressColorView.backgroundColor = lineColor
                    cellFull.letterControlButton.selected = true
                    cellFull.addressTextLabel.text = "C ADDRESS ACTIVE"
                default:
                    cellFull.letterControlButton.selected = false
                    cellFull.addressTextLabel.text = "ADDRESS INACTIVE"
                }
            }
            
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch (current_count, previous_count) {
        case (1, 0):
            return 2
        case (2, 0):
            return dataModel.addressLimit
        case (2, 1):
            return dataModel.addressLimit
        case (3, 2):
            return dataModel.addressLimit
        case (2, 3), (3, 4):
            return dataModel.addressLimit
        case (1, 2):
            return 2
        default: return dataModel.addressLimit
        }
    }
    
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

