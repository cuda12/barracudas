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
    let sbsfKey: String
}


// MARK: - Team Details for all teams

extension TeamDetails {
    
    static var allTeams: [TeamDetails] {
     
        var teamsArray = [TeamDetails]()
        
        teamsArray.append(TeamDetails(abbrTeamName: "NLA", fullTeamName: "NLA", description: "Adult Baseball", sbsfKey: "NLA"))
        teamsArray.append(TeamDetails(abbrTeamName: "FPSB", fullTeamName: "Softball", description: "Women Fastpitch Softball", sbsfKey: "Softball"))
        teamsArray.append(TeamDetails(abbrTeamName: "NLB", fullTeamName: "NLB", description: "Adult Baseball", sbsfKey: "NLB"))
        teamsArray.append(TeamDetails(abbrTeamName: "1. Liga", fullTeamName: "1. Liga", description: "Adult Baseball", sbsfKey: "1Liga"))
        teamsArray.append(TeamDetails(abbrTeamName: "U15", fullTeamName: "Cadets", description: "Youth Baseball", sbsfKey: "Cadets"))
        teamsArray.append(TeamDetails(abbrTeamName: "U12", fullTeamName: "Juveniles", description: "Youth Baseball", sbsfKey: "Juveniles"))
        
        return teamsArray
    }
}
