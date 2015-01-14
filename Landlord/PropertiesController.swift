//
//  PropertiesController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 02.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit
import Parse

class PropertiesController: PTBMasterController, UISplitViewControllerDelegate {
    
// MARK: Properties
    var propertyTypes = [PFObject]()
    
// MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.populate(className: "Property", columnName: "streetAddress")

        // Set property types
        let typesQuery = PFQuery(className: "PropertyType")
        typesQuery.findObjectsInBackgroundWithBlock {
            (propertyTypes: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.propertyTypes = propertyTypes as [PFObject]
            }
        }
    }
}
