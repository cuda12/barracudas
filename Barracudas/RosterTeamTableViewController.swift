//
//  RosterTeamTableViewController.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 20.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class RosterTeamTableViewController: UITableViewController {
    
    // MARK: Members
    let sectionTitles = ["Pitchers", "Infielders", "Outfielders", "Coaches"]
    var teamDetails: TeamDetails!
    var playerDetails: [[PlayersDetails]] = [[], [], [], []]
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // add title to navigation bar
        self.navigationItem.title = teamDetails.abbrTeamName
        
        // add Firebase listener
        addFirebaseListener()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return playerDetails.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerDetails[section].count 
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playersCell", for: indexPath)

        // current players details
        let playerDetails = self.playerDetails[indexPath.section][indexPath.row]
        
        // build cell info
        var heading = "\(playerDetails.firstname) \(playerDetails.lastname)"
        if let number = playerDetails.number {
            heading = "#\(number) " + heading
        }
        
        cell.textLabel?.text = heading
        cell.detailTextLabel?.text = playerDetails.position
        cell.imageView?.image = UIImage(named: "player")        // TODO placeholderImgPlayer

        // download players portrait image
        if let imageUrl = playerDetails.imgUrl {
            FirebaseClient.sharedInstance.downloadAnImage(imageUrl: imageUrl) { (image, error) in
                guard error == nil else {
                    print("TODO error handling")
                    return
                }
                
                // else if the cell is still on screen update its image
                if cell == tableView.cellForRow(at: indexPath) {
                    self.performUIUpdatesOnMain {
                        cell.imageView?.image = image
                    }
                }
            }
        }
        return cell
    }
    
    
    // MARK: - Helpers
    
    func addFirebaseListener() {
        // add a listener to firebase database roster table to download the rosters
        FirebaseClient.sharedInstance.registerRosterListener(toObserve: .childAdded, forTeam: teamDetails.dbKey, completionHandler: { (player) in
            // add players details
            self.playerDetails[self.getSectionIndex(position: player.position)].append(player)
            self.tableView.reloadData()
        })
    }
    
    func getSectionIndex(position: String) -> Int {
        switch position {
        case "RHP", "LHP":
            return 0
        case "1B", "2B", "SS", "3B":
            return 1
        case "LF", "CF", "RF":
            return 2
        default:
            return 3
        }
    }
}
