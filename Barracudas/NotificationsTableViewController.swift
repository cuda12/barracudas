//
//  NotificationsTableViewController.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 20.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class NotificationsTableViewController: UITableViewController {

    // MARK: Members
    
    let notificationTypes = ["all", "game start", "news"]         // TODO struct? model? team depending? in multiple sections
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set navigation bar title
        self.navigationItem.title = "Notifications"
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // TODO TBD team depending?
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationTypes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsCell", for: indexPath) as! NotificationsTableViewCell

        // Configure the cell...
        cell.notificationTitle.text = notificationTypes[indexPath.row]
        // TODO load prev settings
        
        // add cell delegate
        cell.cellDelegate = self
        
        return cell
    }
}


// MARK: - Notifications Settings Cell Delegate extension to handle toggling of the switches

extension NotificationsTableViewController: NotificationSettingsCellDelegate {
    
    func didChangeSwitchState(sender: NotificationsTableViewCell, isOn: Bool) {
        print("delegate switch toggled")
        if let indexPath = self.tableView.indexPath(for: sender) {
            print("at row \(indexPath.row) new state \(isOn)")
            // TODO store in settings
        }
    }
    
}
