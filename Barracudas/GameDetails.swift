//
//  GameDetails.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 06.08.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import Foundation
import Firebase

struct GameDetails {
    
    // MARK: Properties
    
    let snapshotKey: String
    let league: String
    let inning: String?
    let runners: Int?
    let teams: [String]
    let score: [Int]?
    let state: String
    let time: String
    
    
    // MARK: Initializer method
    
    init(withSnapshot snapshot: DataSnapshot) {
        
        // store snapshotkey
        snapshotKey = snapshot.key
        
        // parse json dict to corresponding properties
        let dataDict = snapshot.value as! [String: AnyObject]
        
        league = dataDict[FirebaseClient.Constants.GameResponseKeys.League] as? String ?? "NLA"
        inning = dataDict[FirebaseClient.Constants.GameResponseKeys.Inning] as? String ?? nil
        runners = dataDict[FirebaseClient.Constants.GameResponseKeys.Runners] as? Int ?? nil
        teams = dataDict[FirebaseClient.Constants.GameResponseKeys.Teams] as? [String] ?? ["Away", "Home"]
        score = dataDict[FirebaseClient.Constants.GameResponseKeys.Score] as? [Int] ?? nil
        state = dataDict[FirebaseClient.Constants.GameResponseKeys.State] as? String ?? "notStarted"
        time = dataDict[FirebaseClient.Constants.GameResponseKeys.Time] as? String ?? "11:00"
    }
}
