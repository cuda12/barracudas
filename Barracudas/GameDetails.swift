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
    let teams: [String]
    var inning: Int?
    var isInningTopHalf: Bool?
    var outs: Int?
    var runners: Int?
    var score: [Int]?
    var state: String
    var time: String
    
    enum SetActionTypes {
        case add, subtract
    }
    
    enum Bases {
        case first, second, third
    }
    
    
    // MARK: Calculated Properties
    
    var finalStateString: String? {
        get {
            if state == FirebaseClient.Constants.GameStates.final {
                if let inning = inning, inning != 9 {
                    return "F/\(inning)"
                } else {
                    return "Final"
                }
            } else {
                return nil
            }
        }
    }

    var inningDetailsString: String? {
        get {
            if let inning = inning, let outs = outs, let isTop = isInningTopHalf {
                return (isTop ? "T" : "B") + "\(inning), \(outs) Outs"
            } else {
                return nil
            }
        }
    }
    
    
    // MARK: Initializer method
    
    init(withSnapshot snapshot: DataSnapshot) {
        
        // store snapshotkey
        snapshotKey = snapshot.key
        
        // parse json dict to corresponding properties
        let dataDict = snapshot.value as! [String: AnyObject]
        
        league = dataDict[FirebaseClient.Constants.GameResponseKeys.League] as? String ?? "NLA"
        inning = dataDict[FirebaseClient.Constants.GameResponseKeys.Inning] as? Int ?? nil
        isInningTopHalf = dataDict[FirebaseClient.Constants.GameResponseKeys.InningIsTop] as? Bool ?? nil
        outs = dataDict[FirebaseClient.Constants.GameResponseKeys.Outs] as? Int ?? nil
        runners = dataDict[FirebaseClient.Constants.GameResponseKeys.Runners] as? Int ?? nil
        teams = dataDict[FirebaseClient.Constants.GameResponseKeys.Teams] as? [String] ?? ["Away", "Home"]
        score = dataDict[FirebaseClient.Constants.GameResponseKeys.Score] as? [Int] ?? nil
        state = dataDict[FirebaseClient.Constants.GameResponseKeys.State] as? String ?? "notStarted"
        time = dataDict[FirebaseClient.Constants.GameResponseKeys.Time] as? String ?? "11:00"
    }
    
    
    // MARK: Output method to update firebase database
    
    func asDict() -> [String: AnyObject?] {
        
        var dataDict = [String: AnyObject?]()
        let ResponseKeys = FirebaseClient.Constants.GameResponseKeys.self
        
        dataDict[ResponseKeys.Inning] = inning as AnyObject?
        dataDict[ResponseKeys.InningIsTop] = isInningTopHalf as AnyObject?
        dataDict[ResponseKeys.Outs] = outs as AnyObject?
        dataDict[ResponseKeys.Runners] = runners as AnyObject?
        dataDict[ResponseKeys.Score] = score as AnyObject?
        dataDict[ResponseKeys.State] = state as AnyObject?
        dataDict[ResponseKeys.Time] = time as AnyObject?
        
        return dataDict
    }
    
    
    // MARK: Helpers
    
    mutating func initNewGame() {
        // sets all not defined properties of the game to their default values
        inning = inning ?? 1
        isInningTopHalf = isInningTopHalf ?? true
        outs = outs ?? 0
        runners = runners ?? 0
        score = score ?? [0, 0]
    }
    
    func isInitialized() -> Bool {
        return inning != nil && isInningTopHalf != nil && outs != nil && runners != nil && score != nil
    }

    
    // MARK: Game state functions
    
    mutating func setGameState(to newState: String) {
        state = newState
        if !isInitialized() {
            initNewGame()
        }
    }
    
    mutating func setGameTime(to newTime: String) {
        time = newTime
    }
    
    // MARK: Scoring Functions
    
    mutating func setOuts(action: SetActionTypes? = nil, toValue value: Int? = nil) {
        if !isInitialized() {
            initNewGame()
        }
        
        // handle add/subtract actions
        if let action = action {
            switch action {
            case .add:
                if outs! == 2 {
                    outs = 0
                    inning = inning! + ( isInningTopHalf! ? 0 : 1 )
                    isInningTopHalf = !isInningTopHalf!
                } else {
                    outs = outs! + 1
                }
            case .subtract:
                if outs! == 0 {
                    // make sure minimum is top of first inning
                    if !(inning! == 1 && isInningTopHalf!) {
                        outs = 2
                        inning = inning! - ( isInningTopHalf! ? 1 : 0 )
                        isInningTopHalf = !isInningTopHalf!
                    }
                } else {
                    outs = outs! - 1
                }
            }
        }
        
        // handle setting to a given value
        if let value = value {
            outs = value
        }
    }
    
    mutating func setScore(action: SetActionTypes? = nil, toValues values: [Int]? = nil) {
        if !isInitialized() {
            initNewGame()
        }
        
        // handle add/subtract actions
        if let action = action {
            var delta: Int
            switch action {
            case .add:
                delta = 1
            case .subtract:
                delta = -1
            }
            
            let idx = isInningTopHalf! ? 0 : 1
            score![idx] = max(score![idx] + delta, 0)
        }
        
        // handle setting to given values
        if let values = values {
            score = values
        }
    }
    
    mutating func setRunners(toggleAtBase atBase: Bases? = nil, toValue value: Int? = nil) {
        if !isInitialized() {
            initNewGame()
        }
        
        // handle add/subtract actions
        if let atBase = atBase {
            var delta: Int
            switch atBase {
            case .first:
                delta = (runners! % 10 > 0) ? -1 : 1
            case .second:
                delta = (runners! % 100 >= 10) ? -10 : 10
            case .third:
                delta = (runners! % 1000 >= 100) ? -100 : 100
            }
            
            runners! += delta
        }
        
        // handle setting to a given value
        if let value = value {
            runners = value
        }
    }
}
