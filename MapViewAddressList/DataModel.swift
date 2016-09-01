//
//  DataModel.swift
//  MapViewAddressList
//
//  Created by Maxim on 24.08.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import Foundation

struct DataModel {
    
    var dataModel: [String] = ["ПЕРВЫЙ АДРЕС"]
    
    private let dataSource = ["Address TWO", "Address 3"]
    
    var addressLimit: Int {
        get {
            return 3
        }
    }
    
    mutating func updateDataSource(index: Int, inSection section: Int) -> NSIndexPath {
        
        let element = dataSource[index]
        dataModel.append(element)
        
        print("DATAMODEL COUNT: \(dataModel.count) \n INDEX: \(index) \n DATAMODEL.ENDINDEX: \(dataModel.endIndex-1)")
        
        let indexPath = NSIndexPath(forRow: dataModel.endIndex-1, inSection: section)
        
        return indexPath
    }
    
    
//    mutating func updateDataModel(indexPath: NSIndexPath, element: String) -> [String] {
//        
//       let index = indexPath.row
//        
//            dataModel.insert(element, atIndex: index)
//    
//        return dataModel
//    }
//    
    func generateIndexPath(row: Int) -> NSIndexPath {
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        return indexPath
    }
    
}
