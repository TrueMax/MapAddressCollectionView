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

class GoogleMapViewController: UIViewController, AddressViewDataSource, AddressViewDelegate {
    
    
    //MARK: Конфигурация GoogleMapViewController
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressView: UIView!
    
    
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
        
        easyPeasyConfigureContainerView()
        
    }
    
    func easyPeasyConfigureMapView () {
        mapView <- Edges()
        
    }
    
    func easyPeasyConfigureContainerView () {
        addressView! <- [
            Left(10).to(mapView!),
            Right(10).to(mapView!),
            Top(10).to(mapView!),
            Width(340),
            Height(160).with(.LowPriority)
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
    
    
}

extension GoogleMapViewController {
    // MARK: методы DataSource для AddressView
    
    // MARK: методы Delegate для AddressView
}
