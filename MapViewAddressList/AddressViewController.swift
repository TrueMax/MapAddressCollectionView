//
//  AddressViewController.swift
//  MapViewAddressList
//
//  Created by Maxim on 24.08.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    var selectedFullCell: FullCollectionViewCell?
    var selectedEmptyCell: EmptyCollectionViewCell?
    let recognizerFull = UITapGestureRecognizer() // нажатие для центрирования карты по адресу или поиска нового адреса
    let recognizerEmpty = UITapGestureRecognizer() // нажатие для создания новой ячейки
    let recognizerDelete = UITapGestureRecognizer() // нажатие для удаления ячейки
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.registerClass(FullCollectionViewCell.self, forCellWithReuseIdentifier: "FullCollectionViewCell")
        collectionView.registerClass(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: "EmptyCollectionViewCell")
        
        let nibFull = UINib(nibName: "FullCollectionViewCell", bundle: NSBundle.mainBundle())
        collectionView.registerNib(nibFull, forCellWithReuseIdentifier: "FullCollectionViewCell")
        
        let nibEmpty = UINib(nibName: "EmptyCollectionViewCell", bundle: NSBundle.mainBundle())
        collectionView.registerNib(nibEmpty, forCellWithReuseIdentifier: "EmptyCollectionViewCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.frame = CGRectMake(0, 0, 340, 200)
        
        view.addSubview(collectionView)
        
        recognizerFull.delegate = self
        recognizerEmpty.delegate = self
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellFull = collectionView.dequeueReusableCellWithReuseIdentifier("FullCollectionViewCell", forIndexPath: indexPath) as! FullCollectionViewCell
        
        let cellEmpty = collectionView.dequeueReusableCellWithReuseIdentifier("EmptyCollectionViewCell", forIndexPath: indexPath) as! EmptyCollectionViewCell
        
        if indexPath.row == 0 {
            
            recognizerFull.addTarget(self, action: #selector(self.searchAddress))
            recognizerFull.locationInView(cellFull.letterImage)
            recognizerFull.numberOfTapsRequired = 1
            cellFull.letterImage.addGestureRecognizer(recognizerFull)
            
            return cellFull
        } else {
            recognizerEmpty.addTarget(self, action: #selector(self.addCellAtIndexPath))
            recognizerEmpty.locationInView(cellEmpty.letterImage)
            recognizerEmpty.numberOfTapsRequired = 1
            cellEmpty.letterImage.addGestureRecognizer(recognizerEmpty)
            return cellEmpty
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(320, 50)
    }
    
    // открывает поиск адреса или центрирует карту по выбранному адресу
    func searchAddress () {
        
            let controller = UIAlertController(title: "ADDRESS", message: "Address Found", preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "Close", style: .Cancel, handler: nil))
            presentViewController(controller, animated: true, completion: nil)
        
    }
    
    // добавляет ячейку Full для адреса
    func addCellAtIndexPath () {
        
        
        let controller = UIAlertController(title: "INSERT NEW CELL", message: "SUCCESS", preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "Close", style: .Cancel, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    
}
