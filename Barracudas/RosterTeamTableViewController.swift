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

    var teamDetails: TeamDetails!

    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // add title to navigation bar
        self.navigationItem.title = teamDetails.abbrTeamName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // TODO sections for P IF OF Coaches
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playersCell", for: indexPath)

        // TODO real data
        cell.textLabel?.text = "Kevin Fermin de la Cruz"
        cell.detailTextLabel?.text = "SS"
        cell.imageView?.image = UIImage(named: "player")

        return cell
    }
}
