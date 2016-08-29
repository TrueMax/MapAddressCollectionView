//
//  AddressViewDataSource.swift
//  MapViewAddressList
//
//  Created by Maxim on 29.08.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import Foundation


@objc protocol AddressViewDataSource {

   // var addressArray: [Address] { get set } // Массив объектов типа "Address". Свойства count и addressLimit используются в AddressViewController
    func getAddress()
    
}
