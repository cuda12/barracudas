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
    
    
    // MARK: Outlets
    
    @IBOutlet weak var tableStandings: UITableView!
    @IBOutlet weak var segmentLeagueSelection: UISegmentedControl!
    
    
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
        
        print("selected index of segmentcontroll: \(segmentLeagueSelection.selectedSegmentIndex)")
        
        // init the FetchedResultsController
        print("call frc init")
        initializeFetchedResultscontroller(withLeagueFilter: TeamDetails.allTeams[segmentLeagueSelection.selectedSegmentIndex].abbrTeamName)
        
        // remove any empty cells at the end
        tableStandings.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // load the current standings
        print("download standings from spielplan")
        SBSFClient.sharedInstance().getStandings { (result, error) in
            print("todo handle results")
            print(result ?? "default values - debugging results is nil")
            
            // TODO load here presistent data and make an update request 
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    
    @IBAction func changeLeagueSelection(_ sender: Any) {
        print("new segment control index \(segmentLeagueSelection.selectedSegmentIndex)")
        
        //initializeFetchedResultscontroller(withLeagueFilter: TeamDetails.allTeams[segmentLeagueSelection.selectedSegmentIndex].sbsfKey)
        
        
        let pred = NSPredicate(format: "league = %@", argumentArray: [TeamDetails.allTeams[segmentLeagueSelection.selectedSegmentIndex].abbrTeamName])
        fetchedResultsController.fetchRequest.predicate = pred
        do {
            try fetchedResultsController.performFetch()
            tableStandings.reloadData()
        } catch {
            fatalError("failed to perform fetch")
        }
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
        let sectionInfo = sections[section]
        // add additonal row for header line
        return sectionInfo.numberOfObjects + 1
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
        print("frc will change content")
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














