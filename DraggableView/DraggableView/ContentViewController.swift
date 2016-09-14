//
//  ContentViewController.swift
//  DraggableView
//
//  Created by Maxim on 05.09.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit
import CoreData

class ContentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clearColor()
        view.tintColor = .clearColor()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeSelf(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    let moc = NSManagedObjectContext()
    let moc2 = NSManagedObjectContext()
    
    func contextConfig() {
        moc.parentContext = moc2
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
