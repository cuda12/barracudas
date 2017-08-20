//
//  RostersTableViewController.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 15.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class RostersTableViewController: UITableViewController {
    
    // MARK: Members
    
    let teams = TeamDetails.allTeams
    
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove any empty cells at the end
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source and delegates

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rostersCell", for: indexPath)

        let teamDetails = teams[indexPath.row]
        
        // Configure the cell...
        cell.textLabel?.text = teamDetails.fullTeamName
        cell.detailTextLabel?.text = "\(teamDetails.abbrTeamName) - \(teamDetails.description)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rosterTeamVC = storyboard!.instantiateViewController(withIdentifier: "rosterTeamViewController") as! RosterTeamTableViewController
        
        rosterTeamVC.teamDetails = teams[indexPath.row]
        
        navigationController?.pushViewController(rosterTeamVC, animated: true)
    }
}
