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
    
    var gamesDetails: [GameDetails] = []
    var currentGameDay = ""
    var isSignedIn: Bool = false
    
    // MARK: Outlets
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set navigation bar title
        self.navigationItem.title = "Select a Game"
        
        // set current gameday date
        setGameDayDate()
        
        // connect to firebase
        addFirebaseListeners()
        
        // init ui with signed in state
        setUIAccordingToSignInStatus(isSignedIn: false)
        
        // remove any empty cells at the end
        tableView.tableFooterView = UIView()
    }

   
    // MARK: Actions
    
    @IBAction func signOut(_ sender: Any) {
        FirebaseClient.sharedInstance.signOut { (success) in
            self.performUIUpdatesOnMain {
                self.setUIAccordingToSignInStatus(isSignedIn: !success)
            }
        }
    }
    
    
    // MARK: Helpers
    
    func addFirebaseListeners() {
        FirebaseClient.sharedInstance.registerGamedayListener(toObserve: .childAdded, forDate: currentGameDay) { (game) in
            self.gamesDetails.append(game)
            self.tableView.reloadData()
        }
        FirebaseClient.sharedInstance.registerGamedayListener(toObserve: .childChanged, forDate: currentGameDay) { (game) in
            if let index = self.gamesDetails.index(where: { $0.snapshotKey == game.snapshotKey }) {
                self.gamesDetails[index] = game
                self.tableView.reloadData()
            }
        }
        
        FirebaseClient.sharedInstance.registerAuthListener { (isSignedIn, user) in
            self.setUIAccordingToSignInStatus(isSignedIn: isSignedIn)
            
            if !isSignedIn {
                self.present(FirebaseClient.sharedInstance.authViewController(), animated: true, completion: nil)
            }
        }
    }
    
    func setGameDayDate() {
        // set current gameday to preset value - Udacity review ONLY
        /*  - for reviewing purpose only
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FirebaseClient.Constants.GameDays.DateFormat
        currentGameDay = dateFormatter.string(from: Date())
        */
        currentGameDay = "20170806"
    }
    
    func setUIAccordingToSignInStatus(isSignedIn state: Bool) {
        isSignedIn = state
        signOutButton.isEnabled = state
        tableView.reloadData()
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // automatically resize the rows height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((isSignedIn && gamesDetails.count > 0) ? gamesDetails.count : 1)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSignedIn {
            if gamesDetails.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "liveGamesCell", for: indexPath)
                
                // Configure the cell...
                let gameDetails = gamesDetails[indexPath.row]
                
                cell.textLabel?.text = "\(gameDetails.league): \(gameDetails.teams[0]) vs \(gameDetails.teams[1])"
                
                switch gameDetails.state {
                case FirebaseClient.Constants.GameStates.final:
                    cell.detailTextLabel?.text = gameDetails.finalStateString
                case FirebaseClient.Constants.GameStates.notStarted:
                    cell.detailTextLabel?.text = "\(gameDetails.time), not yet started"
                default:
                    cell.detailTextLabel?.text = "\(gameDetails.state) - \(gameDetails.inningDetailsString ?? "")"
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "noGamesCell", for: indexPath)
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "signInInfoCell", for: indexPath)
            return cell

        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let liveScoringVC = storyboard!.instantiateViewController(withIdentifier: "liveScoringViewController") as! LiveScoringTableViewController
        
        liveScoringVC.gameDetails = gamesDetails[indexPath.row]
        liveScoringVC.gameDay = currentGameDay
        
        navigationController?.pushViewController(liveScoringVC, animated: true)
    }
}
