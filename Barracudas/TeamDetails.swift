//
//  TeamDetails.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 20.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import Foundation

// MARK: - Team Details

struct TeamDetails {
    
    // MARK: Properties
    
    let abbrTeamName: String
    let fullTeamName: String
    let description: String
    let dbKey: String
}


// MARK: - Team Details for all teams

extension TeamDetails {
    
    static var allTeams: [TeamDetails] {
     
        var teamsArray = [TeamDetails]()
        
        teamsArray.append(TeamDetails(abbrTeamName: "NLA", fullTeamName: "NLA", description: "Adult Baseball", dbKey: "NLA"))
        teamsArray.append(TeamDetails(abbrTeamName: "FPSB", fullTeamName: "Softball", description: "Women Fastpitch Softball", dbKey: "Softball"))
        teamsArray.append(TeamDetails(abbrTeamName: "NLB", fullTeamName: "NLB", description: "Adult Baseball", dbKey: "NLB"))
        teamsArray.append(TeamDetails(abbrTeamName: "1. Liga", fullTeamName: "1. Liga", description: "Adult Baseball", dbKey: "1Liga"))
        teamsArray.append(TeamDetails(abbrTeamName: "U15", fullTeamName: "Cadets", description: "Youth Baseball", dbKey: "Cadets"))
        teamsArray.append(TeamDetails(abbrTeamName: "U12", fullTeamName: "Juveniles", description: "Youth Baseball", dbKey: "Juveniles"))
        
        return teamsArray
    }
}
