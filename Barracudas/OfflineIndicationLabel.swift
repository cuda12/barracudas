//
//  OfflineIndicationLabel.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 21.08.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class OfflineIndicationLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    // initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setProperties()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setProperties()
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    }
    
    // set specific properties
    
    func setProperties() {
        self.backgroundColor = UIColor.orange
        self.textColor = UIColor.white
        self.text = "Offline Mode"
        self.textAlignment = .center
    }
}
