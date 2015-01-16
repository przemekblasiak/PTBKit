//
//  PTBSettings.swift
//  Landlord
//
//  Created by Przemyslaw Blasiak on 15.01.2015.
//  Copyright (c) 2015 bprzemyslaw. All rights reserved.
//

import UIKit

/// Key for interactive color.
public let PTBInteractiveColorKey: String! = "InteractiveColor"

/// Key for informative color.
public let PTBInformativeColorKey: String! = "InformativeColor"

/// Key for background color.
public let PTBBackgroundColorKey: String! = "BackgroundColor"

/// Singleton containing framework settings
public class PTBSettings: NSObject {
    
// MARK: Public
    /// Sets a basic palette of colors used throughout the application.
    public func setColorPalette(#interactiveColor: UIColor, informativeColor: UIColor, backgroundColor: UIColor) {
        self.colorPalette[PTBInteractiveColorKey] = interactiveColor
        self.colorPalette[PTBInformativeColorKey] = informativeColor
        self.colorPalette[PTBBackgroundColorKey] = backgroundColor
        
        // Global tint
        UIApplication.sharedApplication().delegate?.window??.tintColor = interactiveColor
        
        // Text caret
        UITextField.appearance().tintColor = interactiveColor
        UITextView.appearance().tintColor = interactiveColor
        
        // Switch
        UISwitch.appearance().onTintColor = interactiveColor

        // Navigation bar
        UINavigationBar.appearance().barTintColor = backgroundColor
        UINavigationBar.appearance().titleTextAttributes = NSDictionary(object: informativeColor, forKey: NSForegroundColorAttributeName)
        
        // Tab bar
        UITabBar.appearance().barTintColor = backgroundColor
    }
    
    /// Represents a palette of colors used throughout the application.
    public var colorPalette: [String: UIColor] = [
        PTBInteractiveColorKey: UIColor.blueColor(),
        PTBInformativeColorKey: UIColor.blackColor(),
        PTBBackgroundColorKey: UIColor.whiteColor()
    ]
    
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
}