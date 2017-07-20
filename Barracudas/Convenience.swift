//
//  Convenience.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 20.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    // GCD Black box - based on the GCDBlackbox by Jarrod Parkers, Udacity
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    
    
    // MARK: - Alerts ? TODO ?
}
