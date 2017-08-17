//
//  LiveGamesTableViewController.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 13.08.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class LiveGamesTableViewController: UITableViewController {

    // MARK: Members
    
    var GamesDetails: [GameDetails] = []
    let currentGameDay = "20170806" // TODO today
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set navigation bar title
        self.navigationItem.title = "Select a Game"
        
        // connect to firebase
        addFirebaseListeners()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Helpers
    
    func addFirebaseListeners() {
        FirebaseClient.sharedInstance.registerGamedayListener(toObserve: .childAdded, forDate: currentGameDay) { (game) in
            self.GamesDetails.append(game)
            self.tableView.reloadData()
        }
        FirebaseClient.sharedInstance.registerGamedayListener(toObserve: .childChanged, forDate: currentGameDay) { (game) in
            if let index = self.GamesDetails.index(where: { $0.snapshotKey == game.snapshotKey }) {
                self.GamesDetails[index] = game
                self.tableView.reloadData()
            }
        }
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GamesDetails.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "liveGamesCell", for: indexPath)

        // Configure the cell...
        let gameDetails = GamesDetails[indexPath.row]
        
        cell.textLabel?.text = "\(gameDetails.league): \(gameDetails.teams[0]) vs \(gameDetails.teams[1])"
        cell.detailTextLabel?.text = "\(gameDetails.time), \(gameDetails.state)"
        // TODO game state more user friendly
        // TODO if final show nice result not time
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let liveScoringVC = storyboard!.instantiateViewController(withIdentifier: "liveScoringViewController") as! LiveScoringTableViewController
        
        liveScoringVC.gameDetails = GamesDetails[indexPath.row]
        liveScoringVC.gameDay = currentGameDay
        
        navigationController?.pushViewController(liveScoringVC, animated: true)
    }
}
