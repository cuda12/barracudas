//
//  StandingsViewController.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 20.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class StandingsViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var tableStandings: UITableView!
    @IBOutlet weak var segmentLeagueSelection: UISegmentedControl!
    
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // remove any empty cells at the end
        tableStandings.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // load the current standings
        print("download standings from spielplan")
        SBSFClient.sharedInstance().getStandings { (result, error) in
            print("todo handle results")
            print(result)
            
            // TODO load here presistent data and make an update request
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - TableView Delegate and DataSource extension

extension StandingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // TODO depending on groups and maybe playoffs
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group \(section)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "standingsCell", for: indexPath) as! StandingsTableViewCell
        
        let index = indexPath.row
        
        // build cell
        if index < 1 {
            cell.backgroundColor = .lightGray
        } else {
            // TODO real data
            cell.labelTeam.text = "Team \(index)"
            cell.labelWL.text = "\(10-index) - \(index)"
            cell.labelPct.text = ".\(10-index)00"
            cell.labelGb.text = "\(index-1)"
            cell.labelStrk.text = "W\(10-index)"
        }
        
        return cell
    }
}
