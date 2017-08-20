//
//  NotificationsTableViewController.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 20.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class NotificationsTableViewController: UITableViewController {

    // version 1.1 connect to firebase notifications (not part of the udacity review)
    
    // MARK: Members
    
    var notifications: CudasNotifications!     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set navigation bar title
        self.navigationItem.title = "Notifications"
        
        initNotifications()
    }

    func initNotifications() {
        // init with previously stored state, if not set default values are used
        notifications = CudasNotifications(withStates: UserDefaults.standard.array(forKey: Constants.userDefaultsNotifications) as? [[Bool]])
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return notifications.sectionTitles[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return notifications.sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.notificationLabels[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsCell", for: indexPath) as! NotificationsTableViewCell

        // Configure the cell...
        cell.notificationTitle.text = notifications.notificationLabels[indexPath.section][indexPath.row]
        cell.notificationSwitch.isOn = notifications.notificationStates[indexPath.section][indexPath.row]
        
        // add cell delegate
        cell.cellDelegate = self
        
        return cell
    }
}


// MARK: - Notifications Settings Cell Delegate extension to handle toggling of the switches

extension NotificationsTableViewController: NotificationSettingsCellDelegate {
    
    func didChangeSwitchState(sender: NotificationsTableViewCell, isOn: Bool) {
         if let indexPath = self.tableView.indexPath(for: sender) {
            if indexPath.row == 0 {
                if indexPath.section == 0 {
                    notifications.switchAll(to: isOn)
                } else {
                    notifications.switchAll(forSection: indexPath.section, to: isOn)
                }
            } else {
                notifications.switchState(forSection: indexPath.section, atIndex: indexPath.row, to: isOn)
            }
            
            // reload the table and update the user defaults with the current states
            tableView.reloadData()
            UserDefaults.standard.set(notifications.notificationStates, forKey: Constants.userDefaultsNotifications)
        }
    }
}


// MARK: - Constants extension 

extension NotificationsTableViewController {
    
    struct Constants {
        static let userDefaultsNotifications = "notificationStates"
    }
}
