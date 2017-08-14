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
        print("toggle on 1st")
    }
    
    @IBAction func toggleRunnerOnSecond(_ sender: Any) {
        print("toggle on 2nd")
    }
    
    @IBAction func toggleRunnerOnThird(_ sender: Any) {
        print("toggle on 3rd")
    }

    @IBAction func clearAllBases(_ sender: Any) {
        print("clear all bases")
    }
    
    @IBAction func startLiveScoring(_ sender: Any) {
        print("start live scoring")
    }
    
    @IBAction func endLiveScoring(_ sender: Any) {
        print("end live scoring")
    }
    
    @IBAction func setLiveScoringPpdRain(_ sender: Any) {
        print("ppd rain")
    }
    
    @IBAction func increaseInnings(_ sender: Any) {
        print("TODO + innings")
    }
    
    @IBAction func decreaseInnings(_ sender: Any) {
        print("TODO - innings")
    }
    
    @IBAction func toggleInningHalf(_ sender: Any) {
        print("TODO switch inning")
    }
    
    @IBAction func increaseOuts(_ sender: Any) {
        print("TODO + outs")
    }
    
    @IBAction func decreaseOuts(_ sender: Any) {
        print("TODO - outs")
    }
    
    @IBAction func increaseRunsAway(_ sender: Any) {
        print("TODO + runs away")
    }
    
    @IBAction func decreaseRunsAway(_ sender: Any) {
        print("TODO - runs away")
    }
    
    @IBAction func increaseRunsHome(_ sender: Any) {
        print("TODO + runs home")
    }
    
    @IBAction func decreaseRunsHome(_ sender: Any) {
        print("TODO - runs home")
        
    }
    
    // TODO change game time
    
    
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
                    
                    // TODO parse firebase inning entry to label, segctrl and outs -> do this in the model
                    //cell.labelInning.text = gameDetails.inning
                    
                    
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "liveGameScore", for: indexPath) as! LiveScoringScoreTableViewCell
                    cell.labelAwayTeam.text = gameDetails.teams[0]
                    cell.labelHomeTeam.text = gameDetails.teams[1]
                    cell.labelAwayRuns.text = String(gameDetails.score?[0] ?? 0)
                    cell.labelHomeRuns.text = String(gameDetails.score?[1] ?? 0)
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
