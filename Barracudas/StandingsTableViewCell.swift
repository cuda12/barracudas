//
//  StandingsTableViewCell.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 20.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class StandingsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTeam: UILabel!
    @IBOutlet weak var labelWL: UILabel!
    @IBOutlet weak var labelPct: UILabel!
    @IBOutlet weak var labelGb: UILabel!
    @IBOutlet weak var labelStrk: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // initialize default values with header attributes
        labelTeam.text = "Team"
        labelWL.text = "W-L"
        labelPct.text = "PCT"
        labelGb.text = "GB"
        labelStrk.text = "STRK"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
