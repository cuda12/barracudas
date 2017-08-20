//
//  TeamsStandings+CoreDataClass.swift
//  
//
//  Created by Andreas Rueesch on 28.07.17.
//
//

import Foundation
import CoreData


public class TeamsStandings: NSManagedObject {

    // MARK: Initializer
    
    convenience init(league: String, recordDetails: [String:AnyObject], context: NSManagedObjectContext) {
        
        // create an instance of the EntityDescription class.
        if let ent = NSEntityDescription.entity(forEntityName: "TeamsStandings", in: context) {
            self.init(entity: ent, insertInto: context)
            
            // match json dict entries to entity properties
            self.league = league
            self.teamname = recordDetails[SBSFConstants.Standings.Teamname] as? String ?? "team1"
            self.rank = (recordDetails[SBSFConstants.Standings.Rank] as! NSString).intValue
            self.wins = (recordDetails[SBSFConstants.Standings.Wins] as! NSString).intValue
            self.losses = (recordDetails[SBSFConstants.Standings.Losses] as! NSString).intValue
            self.pct = (recordDetails[SBSFConstants.Standings.Record] as! NSString).doubleValue
            self.gb = (recordDetails[SBSFConstants.Standings.Gb] as? NSString)?.intValue ?? 0
            self.streak = convertStreakToAbbr(streak: recordDetails[SBSFConstants.Standings.Streak] as? String ?? "Won 0")
            self.group = recordDetails[SBSFConstants.Standings.Group] as? String ?? ""
            self.round = recordDetails[SBSFConstants.Standings.Round] as? String ?? "VR"
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
    
    
    // MARK: Helpers to create abbreviation form of streak string
    
    func convertStreakToAbbr(streak: String) -> String {
        let strComp = streak.components(separatedBy: " ")
        return strComp[0].substring(to: streak.index(streak.startIndex, offsetBy: 1)) + strComp[1]
    }
}
