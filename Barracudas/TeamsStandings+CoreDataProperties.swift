//
//  TeamsStandings+CoreDataProperties.swift
//  
//
//  Created by Andreas Rueesch on 28.07.17.
//
//

import Foundation
import CoreData


extension TeamsStandings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TeamsStandings> {
        return NSFetchRequest<TeamsStandings>(entityName: "TeamsStandings")
    }

    @NSManaged public var gb: Int32
    @NSManaged public var group: String?
    @NSManaged public var league: String?
    @NSManaged public var losses: Int32
    @NSManaged public var pct: Double
    @NSManaged public var rank: Int32
    @NSManaged public var round: String?
    @NSManaged public var streak: String?
    @NSManaged public var teamname: String?
    @NSManaged public var wins: Int32

}
