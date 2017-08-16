//
//  LiveScoringTableViewController.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 13.08.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class LiveScoringTableViewController: UITableViewController {

    // MARK: Members
    
    let sectionTitles = ["Live View", "Live Scoring"]
    var gameDetails: GameDetails!
    var gameDay: String!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set navigation bar title
        self.navigationItem.title = "Live Scoring"
        
        // register nib for live games cell  - TODO add this to schedule view as well
        tableView.register(UINib(nibName: "ScheduleCell", bundle: nil), forCellReuseIdentifier: "liveGameCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    
    @IBAction func toggleRunnerOnFirst(_ sender: Any) {
        gameDetails.setRunners(toggleAtBase: .first)
        performDbUpdate()
    }
    
    @IBAction func toggleRunnerOnSecond(_ sender: Any) {
        gameDetails.setRunners(toggleAtBase: .second)
        performDbUpdate()
    }
    
    @IBAction func toggleRunnerOnThird(_ sender: Any) {
        gameDetails.setRunners(toggleAtBase: .third)
        performDbUpdate()
    }

    @IBAction func clearAllBases(_ sender: Any) {
        gameDetails.setRunners(toValue: 0)
        performDbUpdate()
    }
    
    @IBAction func startLiveScoring(_ sender: Any) {
        gameDetails.setGameState(to: FirebaseClient.Constants.GameStates.live)
        performDbUpdate()
    }
    
    @IBAction func endLiveScoring(_ sender: Any) {
        gameDetails.setGameState(to: FirebaseClient.Constants.GameStates.final)
        performDbUpdate()
    }
    
    @IBAction func setLiveScoringPpdRain(_ sender: Any) {
        gameDetails.setGameTime(to: "ppd rain")
        performDbUpdate()
    }
    
    @IBAction func increaseOuts(_ sender: Any) {
        gameDetails.setOuts(action: .add)
        performDbUpdate()
    }
    
    @IBAction func decreaseOuts(_ sender: Any) {
        gameDetails.setOuts(action: .subtract)
        performDbUpdate()
    }
    
    @IBAction func increaseRunsAway(_ sender: Any) {
        gameDetails.setScore(action: .add)
        performDbUpdate()
    }
    
    @IBAction func decreaseRunsAway(_ sender: Any) {
        gameDetails.setScore(action: .subtract)
        performDbUpdate()
    }
    
    
    // TODO change game time
    
    // TODO just add final result and end game
    
    
    // MARK: - Helpers
    
    func performDbUpdate() {
        FirebaseClient.sharedInstance.updateGameDetails(for: gameDetails, onGameday: gameDay)
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // automatically resize the rows height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 72
        
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if gameDetails.state == FirebaseClient.Constants.GameStates.live {
                return 4
            } else {
                return 2
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "liveGameCell", for: indexPath) as! ScheduleTableViewCell
            cell.updateWithGameDetails(gameDetails)
            return cell
        } else {
            if gameDetails.state == FirebaseClient.Constants.GameStates.live {
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "liveGameInningsOuts", for: indexPath) as! LiveScoringInningsTableViewCell
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "liveGameScore", for: indexPath) as! LiveScoringScoreTableViewCell
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "liveGameSetRunners", for: indexPath) as! LiveScoringSetRunnersTableViewCell
                    cell.imageBases.image = UIImage(named: String(format: "bases%03d", gameDetails.runners ?? 0))
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "liveGameEnd", for: indexPath)
                    return cell
                }
            } else {
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "liveGameStartScoring", for: indexPath)
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "liveGamePpdRain", for: indexPath)
                    return cell
                }
            }
        }
    }
}
