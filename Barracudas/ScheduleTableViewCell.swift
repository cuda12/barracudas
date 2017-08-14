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

    func updateWithGameDetails(_ game: GameDetails) {
        
        
        self.labelAway.text = game.teams[0]
        self.labelHome.text = game.teams[1]
        
        if let score = game.score {
            self.labelScoreAway.text = "\(score[0])"
            self.labelScoreHome.text = "\(score[1])"
        }
        
        if let runners = game.runners {
            self.imageRunners.image = UIImage(named: String(format: "bases%03d", runners))
        } else {
            self.imageRunners.image = nil
        }
        
        switch game.state {
        case FirebaseClient.Constants.GameStates.live:
            self.labelInning.text = game.inning!
        case FirebaseClient.Constants.GameStates.final:
            self.labelInning.text = game.inning!
            self.imageRunners.isHidden = true
        default:
            self.labelInning.text = game.time
            self.imageRunners.isHidden = true
            self.labelScoreHome.isHidden = true
            self.labelScoreAway.isHidden = true
        }
        
        // TODO team icons
        //    - 1. prio stored on device
        //    - 2. prio download from firebase
        //    - 3. prio default logo
        if let iconAway = UIImage(named: "teamIcon_"+game.teams[0]) {
            self.iconAway.image = iconAway
        }
        if let iconHome = UIImage(named: "teamIcon_"+game.teams[1]) {
            self.iconHome.image = iconHome
        }
    }
}
