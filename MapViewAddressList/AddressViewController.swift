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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        recognizerFullLabel.delegate = self
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellFull = collectionView.dequeueReusableCellWithReuseIdentifier("FullCollectionViewCell", forIndexPath: indexPath) as! FullCollectionViewCell
        
        let cellEmpty = collectionView.dequeueReusableCellWithReuseIdentifier("EmptyCollectionViewCell", forIndexPath: indexPath) as! EmptyCollectionViewCell
        
        
        if dataModel.dataModel.count == 2 {
            if indexPath.row == 0 {
                return cellFull
            } else {
                return cellEmpty
            }
        } else if dataModel.dataModel.count == 3 {
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
        
        if sender.tag == 1001 {
            print("my tag is 1001")
        }
        
        dataModel.updateDataModel("Three")
        
        print(dataModel.dataModel.count)
        
        
        let indexPath = dataModel.generateIndexPath(0)
        
       UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
        
            self.addressCollectionView.insertItemsAtIndexPaths([indexPath])
        
           }, completion: nil)
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
