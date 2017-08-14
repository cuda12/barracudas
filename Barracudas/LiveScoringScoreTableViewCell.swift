//
//  LiveScoringScoreTableViewCell.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 13.08.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class LiveScoringScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var labelAwayTeam: UILabel!
    @IBOutlet weak var labelHomeTeam: UILabel!
    @IBOutlet weak var labelAwayRuns: UILabel!
    @IBOutlet weak var labelHomeRuns: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
