//
//  AddressViewController.swift
//  MapViewAddressList
//
//  Created by Maxim on 24.08.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit
import MapKit

class AddressViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var addressMapView: MKMapView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addressCollectionView: UICollectionView!
    
    var selectedFullCell: FullCollectionViewCell?
    var selectedEmptyCell: EmptyCollectionViewCell?
    
    
    // mapView property
    var centerCoordinate: CLLocationCoordinate2D?
    
    let recognizerFullLabel = UITapGestureRecognizer()
    
    var dataModel = DataModel()
    
    internal var addressLimit: Int {
        get {
            return 3
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recognizerFullLabel.delegate = self
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellFull = collectionView.dequeueReusableCellWithReuseIdentifier("FullCollectionViewCell", forIndexPath: indexPath) as! FullCollectionViewCell
        
        let cellEmpty = collectionView.dequeueReusableCellWithReuseIdentifier("EmptyCollectionViewCell", forIndexPath: indexPath) as! EmptyCollectionViewCell
        
        
        if dataModel.dataModel.count < addressLimit {
            if indexPath.row == 0 {
                return cellFull
            } else {
                return cellEmpty
            }
        } else if dataModel.dataModel.count == addressLimit {
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
        return CGSizeMake(320, 50)
    }
    
    // открывает поиск адреса или центрирует карту по выбранному адресу
    func searchAddress () {
        
        centerCoordinate = CLLocationCoordinate2DMake(57, 35)
        addressMapView.setCenterCoordinate(centerCoordinate!, animated: true)
        
    }
    
    // добавляет ячейку Full для адреса
    @IBAction func addCellAtIndexPath (sender: UIButton) {
        
        let touchPoint: CGPoint = sender.convertPoint(CGPointZero, toView: addressCollectionView)
        let touchIndexPath = addressCollectionView.indexPathForItemAtPoint(touchPoint)
        print("TouchIndexPath: \(touchIndexPath)")
        
        if dataModel.dataModel.count < addressLimit {
            
            dataModel.updateDataModel("Three")
            
            let indexPath = dataModel.generateIndexPath(0)
            
            UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                
                self.addressCollectionView.insertItemsAtIndexPaths([indexPath])
                
                }, completion: nil)
          // FIXME: эта часть метода не работает
        } else if dataModel.dataModel.count == addressLimit {
            
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
        sender.backgroundColor = UIColor.blueColor()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.dataModel.count
    }

    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    
}
