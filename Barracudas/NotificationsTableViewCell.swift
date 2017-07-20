//
//  NotificationsTableViewCell.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 20.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

protocol NotificationSettingsCellDelegate {
    func didChangeSwitchState(sender: NotificationsTableViewCell, isOn: Bool)
}


class NotificationsTableViewCell: UITableViewCell {
    
    // MARK: Delegates
    var cellDelegate: NotificationSettingsCellDelegate?
    
    
    // MARK: Outlets
  
    @IBOutlet weak var notificationTitle: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    
    // MARK: Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func toggleSwitch(_ sender: Any) {
        self.cellDelegate?.didChangeSwitchState(sender: self, isOn: notificationSwitch.isOn)
    }
}
