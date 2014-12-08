//
//  PropertyDetailController.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 15.11.2014.
//  Copyright (c) 2014 bprzemyslaw. All rights reserved.
//

import UIKit
import Parse

class PropertyDetailController: UITableViewController {
    var property: PFObject!
    
// MARK: Outlets
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewWillAppear(animated: Bool) {
        if self.property != nil {
            
            // Construct address string
            var address: String = ""
            if let streetAddress: String = self.property["streetAddress"] as? String {
                address += streetAddress
                if let cityAddress: String = self.property["city"] as? String {
                    address += ", "
                    address += cityAddress
                }
            }
            
            self.addressLabel.text = address
            self.notesTextView.text = self.property["note"] as? String
            var c = (self.splitViewController?.viewControllers[0] as UINavigationController).topViewController
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier? == "ShowEditProperty") {
            let destinationController: EditPropertyDetailController! = segue.destinationViewController as? EditPropertyDetailController
            if destinationController != nil {
                destinationController.property = property
            }
        }
    }
}
