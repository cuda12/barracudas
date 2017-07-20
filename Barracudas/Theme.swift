//
//  Theme.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 20.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
    
    // define colors
    
    static let mainColor = UIColor(red: 65.0/255.0, green: 117.0/255.0, blue: 5.0/255.0, alpha: 1.0)
    static let backgroundColor = UIColor(white: 0.8, alpha: 1.0)
    
    static let barStyle = UIBarStyle.default
    
    
    // apply theme methode
    
    static func applyTheme() {
        
        // change tint color globally
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = mainColor
        
        // change background color
        sharedApplication.delegate?.window??.backgroundColor = backgroundColor
        
        // navigation and tab bar
        UINavigationBar.appearance().barStyle = barStyle
        UITabBar.appearance().barStyle = barStyle
        
        // switch buttons
        UISwitch.appearance().onTintColor = mainColor
    }
}
