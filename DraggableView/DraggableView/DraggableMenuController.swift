//
//  DraggableMenuController.swift
//  DraggableMenuController
//
//  Created by Maxim on 04.09.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

protocol DraggableMenuDataSource {
    func dataSourceForDraggableMenu() -> [AnyObject]
}

protocol DraggableMenuDelegate {
    func cellDidSelected(atIndex: Int, withObject object: AnyObject)
}

class DraggableMenuController: UIViewController {
    
    var tapCloseButtonActionHandler : (Void -> Void)?
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: DraggableMenuDataSource?
    private var datasource: [AnyObject] {
            return dataSource as! [AnyObject]
    }
    
    var delegate: DraggableMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let effect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = self.view.bounds
        view.addSubview(blurView)
        view.sendSubviewToBack(blurView)
        
        view.backgroundColor = .clearColor()
        
        tableView.backgroundColor = .clearColor()
        tableView.separatorInset = UIEdgeInsetsZero
        
    }
    
    
}

extension DraggableMenuController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailTableViewCell") as! DetailTableViewCell
        cell.backgroundColor = .clearColor()
        return cell
    }
    
}
