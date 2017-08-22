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
    
    
    // MARK: Outlets
    
    @IBOutlet weak var labelDownload: UILabel!
    @IBOutlet weak var activityIndicationDownload: UIActivityIndicatorView!
    @IBOutlet weak var viewFooterTable: UIView!
    
    
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
        cell.imageView?.image = UIImage(named: "placeholderPlayerImg")
        
        // add an activity indicator programmatically
        let downloadImgIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        downloadImgIndicator.center = CGPoint(x: ((cell.imageView?.image?.size.width)! - downloadImgIndicator.intrinsicContentSize.width)/2.0, y: ((cell.imageView?.image?.size.height)! - downloadImgIndicator.intrinsicContentSize.height)/2.0)
        downloadImgIndicator.hidesWhenStopped = true
        cell.imageView?.addSubview(downloadImgIndicator)
        

        // download players portrait image
        if let imageUrl = playerDetails.imgUrl {
            downloadImgIndicator.startAnimating()
            FirebaseClient.sharedInstance.downloadAnImage(imageUrl: imageUrl) { (image, error) in
                guard error == nil else {
                    // if image couldnt be downloaded just show placeholder, i.e. dont do anything
                    return
                }
                
                // else if the cell is still on screen update its image
                if cell == tableView.cellForRow(at: indexPath) {
                    self.performUIUpdatesOnMain {
                        cell.imageView?.image = image
                        downloadImgIndicator.stopAnimating()
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
            
            // hide download indication if data available
            self.viewFooterTable.isHidden = true
        })
        
        // add the connection state listener
        FirebaseClient.sharedInstance.registerConnectionStateListener { (state) in
            self.performUIUpdatesOnMain {
                self.tableView.tableHeaderView = state ? nil : OfflineIndicationLabel()
                self.setDownloadIndictation(isOnline: state)
            }
        }
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
    

    func setDownloadIndictation(isOnline state: Bool) {
        labelDownload.text = state ? "downloading roster ..." : "check your network connection"
        state ? activityIndicationDownload.startAnimating() : activityIndicationDownload.stopAnimating()
    }
}
