//
//  ScheduleViewController.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 20.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {

    // MARK: Members
    
    var LeaguesAbbr: [String] = []
    var GamesDetails: [[GameDetails]] = []

    var pageIndex: Int!
    var pageViewController: SchedulePageViewController?
    var selectedGameDay: String?
    
    
    // MARK: Outlets
    
    @IBOutlet weak var gameDayTable: UITableView!
    @IBOutlet weak var headerLable: UILabel!
    
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize game details
        initGamesDetails()
        
        // add a listeners to firebase 
        addFirebaseListener()
        
        // add header title 
        headerLable.text = convertToUserfriendlyDateStr(fromDateString: selectedGameDay)
        
        // register nib for live games cell
        gameDayTable.register(UINib(nibName: "ScheduleCell", bundle: nil), forCellReuseIdentifier: "liveGameCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    
    @IBAction func nextGameDay(_ sender: Any) {
        if let pageViewController = pageViewController {
            pageViewController.showNextPage()
        }
    }
    
    @IBAction func prevGameDay(_ sender: Any) {
        if let pageViewController = pageViewController {
            pageViewController.showPrevPage()
        }
    }
    
    // MARK: Helpers
    
    func addFirebaseListener() {
        // add a listener to firebase database gamedays table to download the games
        FirebaseClient.sharedInstance.registerGamedayListener(toObserve: .childAdded, forDate: selectedGameDay!, completionHandler: { (game) in
            // add game details to array
            if let leagueIndex = self.LeaguesAbbr.index(of: game.league) {
                self.GamesDetails[leagueIndex].append(game)
                self.gameDayTable.reloadData()
            }
        })
        
        // add a listener to track game changes
        FirebaseClient.sharedInstance.registerGamedayListener(toObserve: .childChanged, forDate: selectedGameDay!, completionHandler: { (game) in
            print(game)
            if let leagueIndex = self.LeaguesAbbr.index(of: game.league) {
                if let index = self.GamesDetails[leagueIndex].index(where: { $0.snapshotKey == game.snapshotKey }) {
                    self.GamesDetails[leagueIndex][index] = game
                    self.gameDayTable.reloadData()
                }
            }
        })
    }
    
    func initGamesDetails() {
        // loop over all teams and add league abbreviation to section array and init an empty array for the games
        for teamDetail in TeamDetails.allTeams {
            LeaguesAbbr.append(teamDetail.abbrTeamName)
            GamesDetails.append([])
        }
    }
    
    func convertToUserfriendlyDateStr(fromDateString dateStr: String?) -> String? {
        if let dateStr = dateStr {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = FirebaseClient.Constants.GameDays.DateFormat
            
            let date = dateFormatter.date(from: dateStr)
            
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.doesRelativeDateFormatting = true
            dateFormatter.locale = Locale.current
            
            return dateFormatter.string(from: date!)
        } else {
            return nil
        }
    }
}


// MARK: - TableView Delegate and DataSource extension

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    // build sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return LeaguesAbbr.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return LeaguesAbbr[section]
    }
    
    // build cells for each section
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if no games available return one for the corresponding no games scheduled cell
        let noGames = GamesDetails[section].count
        return noGames == 0 ? 1 : noGames
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if GamesDetails[indexPath.section].count == 0 {
            // return no games scheduled cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleNoGamesCell", for: indexPath) 
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "liveGameCell", for: indexPath) as! ScheduleTableViewCell
            
            // add current game details to cell
            cell.updateWithGameDetails(GamesDetails[indexPath.section][indexPath.row])
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
