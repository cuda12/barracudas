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
}


// MARK: - Team Details for all teams

extension TeamDetails {
    
    static var allTeams: [TeamDetails] {
     
        var teamsArray = [TeamDetails]()
        
        teamsArray.append(TeamDetails(abbrTeamName: "NLA", fullTeamName: "NLA", description: "Adult Baseball"))
        teamsArray.append(TeamDetails(abbrTeamName: "NLB", fullTeamName: "NLB", description: "Adult Baseball"))
        teamsArray.append(TeamDetails(abbrTeamName: "1. Liga", fullTeamName: "1. Liga", description: "Adult Baseball"))
        teamsArray.append(TeamDetails(abbrTeamName: "FPSB", fullTeamName: "Softball", description: "Women Fastpitch Softball"))
        teamsArray.append(TeamDetails(abbrTeamName: "U15", fullTeamName: "Cadets", description: "Youth Baseball"))
        teamsArray.append(TeamDetails(abbrTeamName: "U12", fullTeamName: "Juvenilles", description: "Youth Baseball"))
        
        return teamsArray
    }
}
