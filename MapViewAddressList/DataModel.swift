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
    var index: Int?
    
    var addressLimit: Int {
        get {
            return 3
        }
    }
    
    mutating func assignIndex(parameter: NSIndexPath) -> Int {
        index = parameter.row
        return index!
    }
    
    mutating func updateDataModel(element: String) -> [String] {
        
        index = 1
        
            dataModel.insert(element, atIndex: index!)
    
        return dataModel
    }
    
    func generateIndexPath(row: Int) -> NSIndexPath {
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        return indexPath
    }
    
}
