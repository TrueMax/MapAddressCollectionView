//
//  AddressCollectionViewLayout.swift
//  MapViewAddressList
//
//  Created by Maxim on 24.08.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class AddressCollectionViewLayout: UICollectionViewFlowLayout {
    
    var disappearingItemsIndexPaths:[NSIndexPath]?

    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        // 1. unwrap disappearingItemsIndexPaths
        // 2. call super to get the initial attributes
        // 3. check if the indexPaths array contains the current item's indexPath
        // 4. update the layout attributes
        // 5. set the zIndex so the cell is below the other cells
        guard let attributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath),
            indexPaths = disappearingItemsIndexPaths where indexPaths.contains(itemIndexPath) else {
                return nil
        }
        
        attributes.alpha = 1.0
        attributes.transform = CGAffineTransformMakeScale(0.1, 0.1)
        attributes.zIndex = -1
        
        return attributes
    }
    
    

}
