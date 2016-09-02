//
//  GoogleMapViewController.swift
//  MapViewAddressList
//
//  Created by Maxim on 26.08.16.
//  Copyright © 2016 Maxim. All rights reserved.

// Класс содержит карту GMS, которая может являться источником адреса для блока выбора адресов в AddressViewController (MapKit временно)
// Карта получает tap -> CGPoint -> CLLocationCoordinate2D -> обратное геокодирование -> address: String -> передаем адрес через делегата в блок выбора адресов 
// Карта получает адреса от блока выбора адресов. Количество адресов ограничено 3 шт.

import UIKit
import MapKit
import EasyPeasy

class GoogleMapViewController: UIViewController, AddressViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addressCollectionView: UICollectionView!
    @IBOutlet weak var addingButton: UIButton!
    
    private var dataModel = DataModel() // источник данных для AddressViewController
    private var associatedAddress: AnyObject = "Added Address" // тут будет объект типа Address
    
    private let mapAddress = "Одинцово" // сюда будет передаваться адрес после операции обратного геокодирования с карты, это функционал внутренний self
    
    var _address: String {
        get {
                return mapAddress
            }
        set {
            
        }
        
    }
    // если адрес передан карте, карта центрируется по переданному адресу
    var receivedAddress: String? {
        didSet {
            receivedAddress = _address
            centerMapOnLocationWithReceivedAddress()
        }
    }
    
    var centerCoordinate: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let _ = containerView?.frame {
//            
//            var fream = containerView?.frame
//            fream!.size.height = 10
//            containerView?.frame = fream!
//        }
        
        addressCollectionView!.delegate = self
        addressCollectionView!.dataSource = self
        
        let moveGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(moveCollectionViewCells(_:)))
        addressCollectionView!.addGestureRecognizer(moveGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchAddress(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        addressCollectionView!.addGestureRecognizer(tapGestureRecognizer)
        
        easyPeasyConfigureContainerView()
        easyPeasyConfigureCollectionView()
        easyPeasyConfigureAddingButton()
        
    }
    
    func easyPeasyConfigureMapView () {
        mapView <- Edges()
        
    }
    
    func easyPeasyConfigureContainerView () {
        containerView! <- [
            Left(10).to(mapView!),
            Right(10).to(mapView!),
            Top(10).to(mapView!),
            Width().like(view),
            Height(160).with(.LowPriority)
        ]
        
    }
    
    func easyPeasyConfigureCollectionView () {
        addressCollectionView <- [
            Left(0).to(containerView),
            Right(0).to(containerView),
            Top(0).to(containerView),
            Width().like(containerView),
            Height(117).with(.LowPriority)
        ]
        
    }
    
    func easyPeasyConfigureAddingButton () {
        addingButton! <- [
            Left(0).to(containerView!),
            Top(0).to(addressCollectionView!),
            Height(43).with(.HighPriority),
            Width(43).with(.HighPriority)
            
        ]
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
    }

    

    // MARK: Внутренняя кухня карты 
    
    private func makeReverseGeocoding(coordinate: CLLocationCoordinate2D) -> String {
        let address = "Столица"
        return address
    }
    
    // в метод передается адрес в формате dictionary, посредством LocationManager преобразуется в координаты точки с заданной точностью / приближением
    private func makeDirectGeocoding(address: [String: AnyObject]) -> CLLocationCoordinate2D {
        
        let coordinates = CLLocationCoordinate2DMake(57, 35)
        return coordinates
    }
    
    
    private func centerMapOnLocationWithReceivedAddress() {
        
        centerCoordinate = CLLocationCoordinate2DMake(57, 35) // сюда должны передаваться координаты - результат вычислений метода makeDirectGeocoding(_:)
        mapView!.setCenterCoordinate(centerCoordinate!, animated: true)
    }
    
    private func calculateRouteBetweenPoints(points:[CLLocationCoordinate2D]) {
        // метод принимает координаты и возвращает маршрут с отображением на карте
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "mapToAddressViewControllerSegue" {
            let controller = segue.destinationViewController as! AddressViewController
            controller.delegate = self
        }
        
    }
    



// MARK: CollectionView methods 

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

func addCellAtIndexPath (sender: UIButton) {
    
    if sender == addingButton {
        
        if addressCollectionView!.visibleCells().count == 0 {
            
            let initialIndexPath = NSIndexPath(forItem: 0, inSection: 0)
            
            dataModel.updateDataSource(initialIndexPath.row, inSection: initialIndexPath.section)
            
            UIView.animateWithDuration(1.0, delay: 0.7, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                
                self.addressCollectionView!.insertItemsAtIndexPaths([initialIndexPath])
                
                }, completion: { _ in
                    let cell = self.addressCollectionView!.cellForItemAtIndexPath(initialIndexPath) as! FullCollectionViewCell
                    cell.indexPathRow = initialIndexPath.row
                    
//                    self.delegate?.addressViewController!(self, didAddAddress: self.associatedAddress, AtIndex: initialIndexPath.row)
                    
            })
            
        } else {
            
            if let indexPath = addressCollectionView!.indexPathsForVisibleItems().last {
                
                print("DATAMODEL.COUNT: \(dataModel.dataModel.count) \n OLD INDEXPATH: \(indexPath)")
                
                let newIndexPath = dataModel.updateDataSource(indexPath.row, inSection: indexPath.section)
                
                print("NEW INDEXPATH: \(newIndexPath)")
                
                if dataModel.dataModel.count < dataModel.addressLimit {
                    
                    print("DATAMODEL COUNT: \(dataModel.dataModel.count)")
                    
                    
                    UIView.animateWithDuration(1.0, delay: 0.4, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                        
                        self.addressCollectionView!.insertItemsAtIndexPaths([newIndexPath])
                        print("* ADDED CELL AT INDEXPATH, GOING INTO CALLBACK #1: \(newIndexPath)")
                        
                        }, completion: { _ in
                            let cell = self.addressCollectionView!.cellForItemAtIndexPath(newIndexPath) as! FullCollectionViewCell
                            cell.indexPathRow = newIndexPath.row
                            
//                            self.delegate?.addressViewController!(self, didAddAddress: self.associatedAddress, AtIndex: newIndexPath.row)
                            
                            // self.addingButtonPosition()
                    })
                    
                } else if dataModel.dataModel.count == dataModel.addressLimit {
                    
                    
                    UIView.animateWithDuration(1.0, delay: 0.4, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                        
                        self.addressCollectionView!.insertItemsAtIndexPaths([newIndexPath])
                        print("** ADDED CELL AT INDEXPATH, GOING INTO CALLBACK #2: \(newIndexPath)")
                        
                        }, completion: { _ in
                            let cell = self.addressCollectionView!.cellForItemAtIndexPath(indexPath) as! FullCollectionViewCell
                            cell.indexPathRow = indexPath.row
                            
//                            self.delegate?.addressViewController!(self, didAddAddress: self.associatedAddress, AtIndex: newIndexPath.row)
                            
                    })
                     addingButton!.hidden = true
                }
            }
        }
    }
    }
    
    //MARK: Deleting cells
    // удаляет ячейку для адреса
    @IBAction func deleteCellAtIndexPath(sender: UIButton) {
        let touchPoint: CGPoint = sender.convertPoint(CGPointZero, toView: addressCollectionView)
        let touchIndexPath = addressCollectionView!.indexPathForItemAtPoint(touchPoint)
        print("TouchIndexPath: \(touchIndexPath)")
        
        
        if let indexPath = touchIndexPath {
            let layout = AddressCollectionViewLayout()
            layout.disappearingItemsIndexPaths = [indexPath]
            
            dataModel.dataModel.removeAtIndex(indexPath.row)
            UIView.animateWithDuration(0.65, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                self.addressCollectionView!.deleteItemsAtIndexPaths([indexPath])
            }) { (finished: Bool) -> Void in
                layout.disappearingItemsIndexPaths = nil
                // self.addingButtonPosition()
            }
            
            
        }
        // addressCellAddingButton.hidden = false
    }
    
    //MARK: Moving cells
    // перемещает ячейки с адресами
    
    func moveCollectionViewCells(gestureRecognizer: UILongPressGestureRecognizer) {
        
        switch gestureRecognizer.state {
            
        case .Began:
            guard let initialIndexPath = addressCollectionView!.indexPathForItemAtPoint(gestureRecognizer.locationInView(addressCollectionView)) else {
                break
            }
            addressCollectionView!.beginInteractiveMovementForItemAtIndexPath(initialIndexPath)
        case .Changed:
            addressCollectionView!.updateInteractiveMovementTargetPosition(gestureRecognizer.locationInView(gestureRecognizer.view))
        case .Ended:
            addressCollectionView!.endInteractiveMovement()
        default: addressCollectionView!.cancelInteractiveMovement()
            
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
        let touchIndexPath = addressCollectionView!.indexPathForItemAtPoint(touchPoint)
        
        if let indexPath = touchIndexPath {
            let cell = addressCollectionView!.cellForItemAtIndexPath(indexPath) as! FullCollectionViewCell
            
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
        let touchIndexPath = addressCollectionView!.indexPathForItemAtPoint(touchPoint)
        
        if let indexPath = touchIndexPath {
            
            //            delegate?.addressViewController!(self, didActivateAddress: associatedAddress!, AtIndex: indexPath.row)
            
            
            
            let cellFull = addressCollectionView!.cellForItemAtIndexPath(indexPath) as! FullCollectionViewCell
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
        let visibleCells = addressCollectionView!.visibleCells()
        for cell in visibleCells {
            if cell is FullCollectionViewCell {
                cell.selected = false
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataModel.dataModel.count
        
    }
}






// MARK: AddressViewDelegate methods
extension GoogleMapViewController {
    
    func addressViewController(addressesVC: AddressViewController, didActivateAddress address: AnyObject, AtIndex index: Int) {
        centerMapOnLocationWithReceivedAddress()
    }
    
    func addressViewController(addressesVC: AddressViewController, didAddAddress address: AnyObject, AtIndex index: Int) -> AnyObject? {
        
        
        
        return nil
    }
    
    
}
