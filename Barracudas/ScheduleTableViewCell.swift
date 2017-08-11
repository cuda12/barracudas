//
//  ScheduleTableViewCell.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 06.08.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var iconAway: UIImageView!
    @IBOutlet weak var labelAway: UILabel!
    @IBOutlet weak var labelScoreAway: UILabel!
    @IBOutlet weak var iconHome: UIImageView!
    @IBOutlet weak var labelHome: UILabel!
    @IBOutlet weak var labelScoreHome: UILabel!
    @IBOutlet weak var imageRunners: UIImageView!
    @IBOutlet weak var labelInning: UILabel!
    @IBOutlet weak var buttonLiveTicker: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // prepared for version 2.0 (first release dont show any details)
        buttonLiveTicker.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
