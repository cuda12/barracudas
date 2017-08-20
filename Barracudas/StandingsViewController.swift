//
//  StandingsViewController.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 20.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit
import CoreData

class StandingsViewController: UIViewController {
    
    // MARK: Properties
    
    let stack = (UIApplication.shared.delegate as! AppDelegate).stack
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    let refreshControl = UIRefreshControl()
    
    
    // MARK: Outlets
    
    @IBOutlet weak var tableStandings: UITableView!
    @IBOutlet weak var segmentLeagueSelection: UISegmentedControl!
    @IBOutlet weak var footerLabelLastUpdate: UILabel!
    @IBOutlet weak var footerLabelSuccess: UILabel!
    
    
    // MARK: Initiliazier for FetchResultsController
    
    func initializeFetchedResultscontroller(withLeagueFilter dbKey: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TeamsStandings")
        
        // sort according to ranking
        let rankSort = NSSortDescriptor(key: "rank", ascending: true)
        let groupSort = NSSortDescriptor(key: "group", ascending: true)
        request.sortDescriptors = [groupSort, rankSort]
        
        // filter league
        let pred = NSPredicate(format: "league = %@", argumentArray: [dbKey])
        request.predicate = pred
        
        // build fetchedResultController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: stack.context, sectionNameKeyPath: "group", cacheName: nil)
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initilize FetchedResultsController: \(error)")
        }
    }
    
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init the FetchedResultsController
        initializeFetchedResultscontroller(withLeagueFilter: TeamDetails.allTeams[segmentLeagueSelection.selectedSegmentIndex].abbrTeamName)
        
        // setup tableview
        setupTableView()
        
        // update the standings
        updateStandings()
    }
    
    
    // MARK: Methods
    
    func updateStandings() {
        // indicate refreshing
        self.refreshControl.beginRefreshing()
        
        // call sbsf client to download the standings
        SBSFClient.sharedInstance().getStandings { (success, error) in
            self.performUIUpdatesOnMain {
                self.refreshControl.endRefreshing()
                self.setFooterLabelTitle(to: success)
                if success {
                    self.updateLastUpdateTimeStamp()
                }
            }
        }
    }
    
    
    // MARK: Actions
    
    @IBAction func changeLeagueSelection(_ sender: Any) {
        let pred = NSPredicate(format: "league = %@", argumentArray: [TeamDetails.allTeams[segmentLeagueSelection.selectedSegmentIndex].abbrTeamName])
        fetchedResultsController.fetchRequest.predicate = pred
        do {
            try fetchedResultsController.performFetch()
            tableStandings.reloadData()
        } catch {
            fatalError("failed to perform fetch")
        }
    }
    
    @objc private func refreshStandingData(_ sender: Any) {
        updateStandings()
    }
    
    
    // MARK: Helpers
    
    func setupTableView() {
        // set footer labels
        setFootLabelUpdate(to: UserDefaults.standard.value(forKey: "lastStandingsUpdate") as? Date)
        setFooterLabelTitle(to: true)
        
        // add refresh control to the table view
        tableStandings.refreshControl = refreshControl
        
        // configure refresh control
        refreshControl.addTarget(self, action: #selector(refreshStandingData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Updating Standings ...")
    }
    
    func updateLastUpdateTimeStamp() {
        let currentDate = Date()
        UserDefaults.standard.set(currentDate, forKey: "lastStandingsUpdate")
        setFootLabelUpdate(to: currentDate)
    }
    
    func setFootLabelUpdate(to date: Date?) {
        if let date = date {
            footerLabelLastUpdate.text = "last update: \(DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .medium))"
        } else {
            footerLabelLastUpdate.text = "no previously downloaded data available"
        }
    }
    
    func setFooterLabelTitle(to success: Bool) {
        footerLabelSuccess.text = success ? "Standings are provided by spielplan.ch" : "couldnt download standings from spielplan.ch, check your network connection"
    }
}


// MARK: - TableView Delegate and DataSource extension

extension StandingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name ?? nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        
        // add additonal row for header line
        let numberOfRows = sections[section].numberOfObjects + 1
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "standingsCell", for: indexPath) as! StandingsTableViewCell
        
        // get indices of indexPath
        let index = indexPath.row
        let section = indexPath.section
        
        // build cell
        if index < 1 {
            // for the header cell, make use of the default values of the cell
            cell.backgroundColor = .lightGray
            cell.awakeFromNib()
        } else {
            cell.backgroundColor = .white
            
            // subtract the header line from the index path for the fetchedResultsController
            guard let object = self.fetchedResultsController?.object(at: IndexPath(row: index-1, section: section)) as? TeamsStandings else {
                fatalError("attempt to configure cell without a managed objetct")
            }
            
            cell.labelTeam.text = object.teamname
            cell.labelWL.text = "\(object.wins) - \(object.losses)"
            cell.labelPct.text = "\(object.pct)"
            cell.labelGb.text = "\(object.gb)"
            cell.labelStrk.text = "\(object.streak ?? "-")"
        }
        
        return cell
    }
}


// MARK: - NSFetchedResultsController delegate methods

extension StandingsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
         tableStandings.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableStandings.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableStandings.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableStandings.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableStandings.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableStandings.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableStandings.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableStandings.endUpdates()
    }
}
