//
//  LiveScoringInningsTableViewCell.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 13.08.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class LiveScoringInningsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelInning: UILabel!
    @IBOutlet weak var labelOuts: UILabel!
    @IBOutlet weak var segCtrlHalfInning: UISegmentedControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
