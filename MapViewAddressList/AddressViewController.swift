//
//  AddressViewController.swift
//  MapViewAddressList
//
//  Created by Maxim on 24.08.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit
import MapKit

class AddressViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GoogleMapViewControllerDelegate  {
    
    @IBOutlet weak var addressCollectionView: UICollectionView!
    
    var dataModel = DataModel() // источник данных для AddressViewController
    var mapDelegate: GoogleMapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapDelegate = self
        addressCollectionView.delegate = self
        addressCollectionView.dataSource = self
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellFull = collectionView.dequeueReusableCellWithReuseIdentifier("FullCollectionViewCell", forIndexPath: indexPath) as! FullCollectionViewCell
        
        let cellEmpty = collectionView.dequeueReusableCellWithReuseIdentifier("EmptyCollectionViewCell", forIndexPath: indexPath) as! EmptyCollectionViewCell
        
        
        if dataModel.dataModel.count < dataModel.addressLimit {
            if indexPath.row == 0 {
                return cellFull
            } else {
                return cellEmpty
            }
        } else if dataModel.dataModel.count == dataModel.addressLimit {
            if indexPath.row == 2 {
                return cellEmpty
            } else {
                return cellFull
            }
            
        } else {
            return cellFull
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width - 20
        let cellHeight = CGFloat(50)
        let size = CGSizeMake(cellWidth, cellHeight)
        return size
    }
    
    // открывает поиск адреса - условный SearchViewController, но вообще этот метод нужно переместить, а оставить только функционал ячейки CollectionView: нажали на кнопку SEARCH - ищем адрес, button.tag = indexPath.item
    func searchAddress () {
        
    }
    
    // добавляет ячейку Full для адреса
    @IBAction func addCellAtIndexPath (sender: UIButton) {
        
        let touchPoint: CGPoint = sender.convertPoint(CGPointZero, toView: addressCollectionView)
        let touchIndexPath = addressCollectionView.indexPathForItemAtPoint(touchPoint)
        print("TouchIndexPath: \(touchIndexPath)")
        
        if dataModel.dataModel.count < dataModel.addressLimit {
            
            dataModel.updateDataModel("Three")
            
            let indexPath = dataModel.generateIndexPath(0)
            
            UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                
                self.addressCollectionView.insertItemsAtIndexPaths([indexPath])
                
                }, completion: nil)
          // FIXME: эта часть метода не работает, потому что требуется вносить изменения в layout
        } else if dataModel.dataModel.count == dataModel.addressLimit {
            
            print(dataModel.dataModel.count)
            if let indexPath = touchIndexPath {
                addressCollectionView.dequeueReusableCellWithReuseIdentifier("FullCollectionViewCell", forIndexPath: indexPath)
                    addressCollectionView.reloadItemsAtIndexPaths([indexPath])
                
            }
        }
        
        
    }
    
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
            }
        }
        
    }
    
    
    @IBAction func addressFieldMakeActive(sender: UIButton) {
        let title = mapDelegate?.address ?? "Default placeholder address"
        sender.setTitle(title, forState: .Normal)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.dataModel.count
    }

    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
// MARK: вспомогательные функции 
    
    
}

