//
//  PlayersDetails.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 06.08.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import Foundation
import Firebase

struct PlayersDetails {
    
    // MARK: Properties
    
    let snapshotKey: String
    let firstname: String
    let lastname: String
    let position: String
    let additionalPositions: [String]?
    let number: Int?
    let imgUrl: String?
    
    
    // MARK: Initializer method
    
    init(withSnapshot snapshot: DataSnapshot) {
        
        // store snapshotkey
        snapshotKey = snapshot.key
        
        // parse json dict to corresponding properties
        let dataDict = snapshot.value as! [String: AnyObject]
        
        firstname = dataDict[FirebaseClient.Constants.RosterResponseKeys.FirstName] as? String ?? "Firstname"
        lastname = dataDict[FirebaseClient.Constants.RosterResponseKeys.LastName] as? String ?? "Lastname"
        position = dataDict[FirebaseClient.Constants.RosterResponseKeys.Position] as? String ?? "Position"
        additionalPositions = dataDict[FirebaseClient.Constants.RosterResponseKeys.AdditionalPosition] as? [String] ?? nil
        number = dataDict[FirebaseClient.Constants.RosterResponseKeys.Number] as? Int ?? nil
        imgUrl = dataDict[FirebaseClient.Constants.RosterResponseKeys.ImageUrl] as? String ?? nil
    }
}
