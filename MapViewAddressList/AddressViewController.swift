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
    
        optional var address: String { get set } // get - делегат берет адрес у карты, set - делегат назначает адрес для карты сам
        optional var addressIsProvidedByMap: Bool { get } // опции 1. true - адрес пришел с карты 2. false - адрес введен иным образом
        func addressDidTapped() // пользователь нажал ячейку с адресом на делегате 
}


class AddressViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
//    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//        addressCollectionView.setNeedsLayout()
//    }
    
    @IBOutlet weak var addressCollectionView: UICollectionView!
    
    var dataModel = DataModel() // источник данных для AddressViewController
    var delegate: AddressViewDelegate?
    
    var current_count = 0
    
    var previous_count = 0
   // var ascending_count: Bool {
    //    return current_count > previous_count
   // }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressCollectionView.delegate = self
        addressCollectionView.dataSource = self
        
        let moveGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(moveCollectionViewCells(_:)))
        addressCollectionView.addGestureRecognizer(moveGestureRecognizer)
        
        addressCollectionView.translatesAutoresizingMaskIntoConstraints = true
        
        current_count = dataModel.dataModel.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellFull = collectionView.dequeueReusableCellWithReuseIdentifier("FullCollectionViewCell", forIndexPath: indexPath) as! FullCollectionViewCell
        
        let cellEmpty = collectionView.dequeueReusableCellWithReuseIdentifier("EmptyCollectionViewCell", forIndexPath: indexPath) as! EmptyCollectionViewCell
        
        switch (indexPath.row) {
        case 0:
            if current_count < 2 {
            cellFull.deleteButton.enabled = false
            return cellFull
            
            } else {
                return cellFull
            }
        case 1:
            if current_count == 2 {
                return cellFull
            } else {
            return cellEmpty
            }
        case 2:
            if current_count == 3 {
                return cellFull
            } else {
                return cellEmpty
            }
        default:
            return cellEmpty
        }
        
//        if ascending_count {
//            switch (current_count, previous_count) {
//            case (1, 0):
//                
//                print ("DATAMODEL.COUNT = \(dataModel.dataModel.count)")
//                if indexPath.row == 0 {
//                    cellFull.deleteButton.enabled = false
//                    return cellFull
//                } else {
//                    return cellEmpty
//                }
//            case (2, 1):
//                print ("DATAMODEL.COUNT = \(dataModel.dataModel.count)")
//                if indexPath.row < 2 {
//                    cellFull.deleteButton.enabled = true
//                    return cellFull
//                } else {
//                    return cellEmpty
//                }
//            case (3, 2):
//                print ("DATAMODEL.COUNT = \(dataModel.dataModel.count)")
//                cellFull.deleteButton.enabled = true
//                return cellFull
//                
//            default: break
//            }
//        } else {
//            return cellEmpty
//        }
        
    
        
//        if dataModel.dataModel.count < dataModel.addressLimit {
//            if indexPath.row == 0 {
//                cellFull.deleteButton.enabled = false
//                return cellFull
//            } else {
//                return cellEmpty
//            }
//        } else if dataModel.dataModel.count == dataModel.addressLimit {
//            if indexPath.row == 2 {
//                cellFull.deleteButton.enabled = true
//                return cellFull
//            } else {
//                cellFull.deleteButton.enabled = true
//                return cellFull
//            }
//            
//        } else {
//            cellFull.deleteButton.enabled = true
//            return cellFull
//        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width - 20
        let cellHeight = CGFloat(40)
        let size = CGSizeMake(cellWidth, cellHeight)
        return size
    }
    
    // открывает поиск адреса - условный SearchViewController, но вообще этот метод нужно переместить, а оставить только функционал ячейки CollectionView: нажали на кнопку SEARCH - ищем адрес, button.tag = indexPath.item
    func searchAddress () {
        
    }
    
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
                
                // completion почему-то не работает, надо разбираться, почему
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
    }
    
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
        default: addressCollectionView.cancelInteractiveMovement()
            
        }
        
    }
    
    // метод не работает - не вызывается, потому что должен следовать за вызовом collectionView (shouldShowMenuForItemAt: ), а мы не вызываем меню редактирования
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let firstElement = dataModel.dataModel.removeAtIndex(sourceIndexPath.row)
        dataModel.dataModel.insert(firstElement, atIndex: destinationIndexPath.row)
    }
    
    
    @IBAction func addressFieldMakeActive(sender: UIButton) {
        let title = "Default placeholder address"
        sender.setTitle(title, forState: .Normal)
        
        // здесь нужно передать делегату значение
        delegate?.addressDidTapped()
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
// MARK: вспомогательные функции 
    
    
}

