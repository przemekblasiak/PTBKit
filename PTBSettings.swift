//
//  PTBSettings.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 15.01.2015.
//  Copyright (c) 2015 bprzemyslaw. All rights reserved.
//

import UIKit

/// Singleton containing framework settings
public class PTBSettings {
    
// MARK: Public
    /// Sets a basic palette of colors used throughout the application.
    public func setColorPalette(#interactiveColor: UIColor, informativeColor: UIColor, backgroundColor: UIColor) {
        self.colorPalette["Interactive"] = interactiveColor
        self.colorPalette["Informative"] = informativeColor
        self.colorPalette["Background"] = backgroundColor
        
        // Global tint
        UIApplication.sharedApplication().delegate?.window??.tintColor = interactiveColor
        
        // Text caret
        UITextField.appearance().tintColor = interactiveColor
        UITextView.appearance().tintColor = interactiveColor

        // Navigation bar
        UINavigationBar.appearance().barTintColor = backgroundColor
        UINavigationBar.appearance().titleTextAttributes = NSDictionary(object: informativeColor, forKey: NSForegroundColorAttributeName)
        
        // Tab bar
        UITabBar.appearance().barTintColor = backgroundColor
    }
    
    // Singleton instance
    public class var sharedInstance: PTBSettings {
        struct Static {
            static var instance: PTBSettings!
        }
        if Static.instance == nil {
            Static.instance = PTBSettings()
        }
        return Static.instance
    }
    
// MARK: Properties
    var colorPalette = [
        "Interactive": UIColor.blueColor(),
        "Informative": UIColor.blackColor(),
        "Background": UIColor.whiteColor()
    ]
}