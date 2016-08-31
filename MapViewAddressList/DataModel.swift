//
//  DataModel.swift
//  MapViewAddressList
//
//  Created by Maxim on 24.08.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import Foundation

struct DataModel {
    
    var dataModel: [String] = ["One Address"]
    
    
    var addressLimit: Int {
        get {
            return 3
        }
    }
    
    
    
    mutating func updateDataModel(indexPath: NSIndexPath, element: String) -> [String] {
        
       let index = indexPath.row
        
            dataModel.insert(element, atIndex: index)
    
        return dataModel
    }
    
    func generateIndexPath(row: Int) -> NSIndexPath {
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        return indexPath
    }
    
}
