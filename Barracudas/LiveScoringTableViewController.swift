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
    let AdminButtons = ["start live scoring", "enter final score", "change game time", "ppd rain", "end game", "set time"]
    
    var gameDetails: GameDetails!
    var gameDay: String!
    var adminControls: AdminControls = .defaultControls
    
    enum AdminControls {
        case defaultControls, liveScoring, finalResult, gameTimeChange
    }
    
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set navigation bar title
        self.navigationItem.title = "Live Scoring"
        
        // register nib for live games cell  - TODO add this to schedule view as well
        tableView.register(UINib(nibName: "ScheduleCell", bundle: nil), forCellReuseIdentifier: "liveGameCell")
        
        // set init admin controls depending on game state
        adminControls = (gameDetails.state == FirebaseClient.Constants.GameStates.live) ? .liveScoring : .defaultControls
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
    
    @IBAction func increaseOuts(_ sender: Any) {
        gameDetails.setOuts(action: .add)
        performDbUpdate()
    }
    
    @IBAction func decreaseOuts(_ sender: Any) {
        gameDetails.setOuts(action: .subtract)
        performDbUpdate()
    }
    
    @IBAction func increaseRuns(_ sender: Any) {
        gameDetails.setScore(action: .add)
        performDbUpdate()
    }
    
    @IBAction func decreaseRuns(_ sender: Any) {
        gameDetails.setScore(action: .subtract)
        performDbUpdate()
    }
    
    @IBAction func performButtonCellAction(_ sender: Any) {
        // depending on the current admin view perform corresponding action
        switch adminControls {
            
        case .defaultControls:
            // get the index of the tapped row
            guard let cell = (sender as AnyObject).superview??.superview as? LiveScoringButtonTableViewCell, let index = tableView.indexPath(for: cell)?.row else {
                return
            }

            // only the default controller has multiple buttons
            switch index {
            case 0:
                startLiveScoring()
            case 1:
                switchAdminControlPage(to: .finalResult)
            case 2:
                switchAdminControlPage(to: .gameTimeChange)
            default:
                setGameTime(to: "ppd rain")
            }
            
        case .liveScoring:
            // end live scoring
            endLiveScoring()
            
        case .finalResult:
            // set gamedetails to inputed score and inning
            gameDetails.setScore(toValues: [getFinalResult(at: 0), getFinalResult(at: 1)])
            gameDetails.inning = getFinalResult(at: 2, defaultValue: 9)
            // end live scoring
            endLiveScoring()
            
        case .gameTimeChange:
            if let newGameTime = getGameTime() {
                setGameTime(to: newGameTime)
            }
        }
    }
    
    @IBAction func changeGameTime(_ sender: Any) {
        if let pickedDate = (sender as? UIDatePicker)?.date, let label = (tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? LiveChangeGameTimeTableViewCell)?.labelGameTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            label.text = dateFormatter.string(from: pickedDate)
        }
    }
    
    
    // MARK: - Admin methods
    
    func startLiveScoring() {
        gameDetails.setGameState(to: FirebaseClient.Constants.GameStates.live)
        performDbUpdate()
        switchAdminControlPage(to: .liveScoring)
    }
    
    func endLiveScoring() {
        gameDetails.setGameState(to: FirebaseClient.Constants.GameStates.final)
        performDbUpdate()
        switchAdminControlPage(to: .defaultControls)
    }
    
    func setGameTime(to newGameTime: String) {
        gameDetails.setGameTime(to: newGameTime)
        gameDetails.setGameState(to: FirebaseClient.Constants.GameStates.notStarted)
        performDbUpdate()
        switchAdminControlPage(to: .defaultControls)
    }
    
    
    // MARK: - Helpers
    
    func performDbUpdate() {
        FirebaseClient.sharedInstance.updateGameDetails(for: gameDetails, onGameday: gameDay)
        tableView.reloadData()
    }
    
    func switchAdminControlPage(to page: AdminControls) {
        adminControls = page
        tableView.reloadData()
    }
    
    func getFinalResult(at index: Int, defaultValue defValue: Int = 0) -> Int {
        return Int(((tableView.cellForRow(at: IndexPath(row: index, section: 1)) as? LiveGameFinalResultTableViewCell)?.input.text)!) ?? defValue
    }
    
    func getGameTime() -> String? {
        return (tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? LiveChangeGameTimeTableViewCell)?.labelGameTime.text
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
            switch adminControls {
            case .liveScoring, .defaultControls, .finalResult:
                return 4
            case .gameTimeChange:
                return 3
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "liveGameCell", for: indexPath) as! ScheduleTableViewCell
            cell.updateWithGameDetails(gameDetails)
            return cell
        } else {
            switch adminControls {
            case .liveScoring:
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
                    let cell = tableView.dequeueReusableCell(withIdentifier: "liveGameButton", for: indexPath) as! LiveScoringButtonTableViewCell
                    cell.button.setTitle(AdminButtons[4], for: .normal)
                    return cell
                }
            case .finalResult:
                if indexPath.row <= 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "liveGameFinalResult", for: indexPath) as! LiveGameFinalResultTableViewCell
                    cell.label.text = (indexPath.row < 2) ? gameDetails.teams[indexPath.row] : "Inning"
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "liveGameButton", for: indexPath) as! LiveScoringButtonTableViewCell
                    cell.button.setTitle(AdminButtons[4], for: .normal)
                    return cell
                }
            case .gameTimeChange:
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "liveChangeGameTime", for: indexPath) as! LiveChangeGameTimeTableViewCell
                    cell.labelGameTime.text = gameDetails.time
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "liveChangeGameTimePicker", for: indexPath)
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "liveGameButton", for: indexPath) as! LiveScoringButtonTableViewCell
                    cell.button.setTitle(AdminButtons[5], for: .normal)
                    return cell
                }
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "liveGameButton", for: indexPath) as! LiveScoringButtonTableViewCell
                cell.button.setTitle(AdminButtons[indexPath.row], for: .normal)
                return cell
            }
        }
    }
}
