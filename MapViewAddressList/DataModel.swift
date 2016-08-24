//
//  DataModel.swift
//  MapViewAddressList
//
//  Created by Maxim on 24.08.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import Foundation
import UIKit

class DataModel: UIViewController {
    
    var dataModel: [String] = ["One", "Two"]
    var index: Int?
    
    func assignIndex(parameter: NSIndexPath) -> Int {
        index = parameter.row
        return index!
    }
    
    func updateDataModel(element: String) -> [String] {
        
        index = 1
        
            dataModel.insert(element, atIndex: index!)
    
        return dataModel
    }
    
    func generateIndexPath(row: Int) -> NSIndexPath {
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        return indexPath
    }
    
}
