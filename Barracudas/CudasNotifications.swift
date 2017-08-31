//
//  CudasNotifications.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 17.08.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import Foundation
import FirebaseMessaging

struct CudasNotifications {
    
    enum NotificationTypes {
        case club, team
    }
    
    // pre set section titles and notification types with team details model
    let sectionTitles: [String] = ["Club"] + TeamDetails.allAbbrivitaions
    let notificationTypes: [NotificationTypes] = [.club] + [NotificationTypes](repeatElement(.team, count: TeamDetails.allAbbrivitaions.count))

    // mutable elements
    var notificationStates: [[Bool]]
    var notificationLabels: [[String]] {
        get {
            var labels: [[String]] = []
            for notificationType in notificationTypes {
                switch notificationType {
                case .club:
                    labels.append(["all notifications", "news"])
                case .team:
                    labels.append(["all", "news", "runs scored", "final score"])
                }
            }
            return labels
        }
    }
    
    var initStatesAllFalse: [[Bool]] {
        get {
            var states: [[Bool]] = []
            for labels in notificationLabels {
                states.append([Bool](repeatElement(false, count: labels.count)))
            }
            
            return states
        }
    }
    
    // MARK: init methods
    
    init(withStates states: [[Bool]]? = nil) {
        // init with states if provided, otherwise with false for all states
        
        if let states = states {
            notificationStates = states
        } else {
            var states: [[Bool]] = [[Bool](repeatElement(false, count: 2))]
            for _ in TeamDetails.allAbbrivitaions {
                states.append([Bool](repeatElement(false, count: 4)))
            }

            notificationStates = states
        }
    }
    
    
    // MARK: switching states methods
    
    mutating func switchAll(forSection sectionIndex: Int? = nil, to newState: Bool) {
        if let sectionIndex = sectionIndex {
            for var idx in 0..<notificationStates[sectionIndex].count {
                switchState(forSection: sectionIndex, atIndex: idx, to: newState)
                idx += 1
            }
        } else {
            for var jdx in 0..<notificationStates.count {
                switchAll(forSection: jdx, to: newState)
                jdx += 1
            }
        }
    }
    
    mutating func switchState(forSection sectionIndex: Int, atIndex index: Int, to newState: Bool) {
        // set particular state
        notificationStates[sectionIndex][index] = newState
        
        // set first if not all true to false otherwise to true
        notificationStates[sectionIndex][0] = !notificationStates[sectionIndex].dropFirst().contains(false)
        
        // same holds for (0, 0) -> i.e. all notifications
        notificationStates[0][0] = !notificationStates.dropFirst().contains(where: { (states) -> Bool in
            return states.contains(false)
        }) && !notificationStates[0].dropFirst().contains(false)
    }

    
    // MARK: subscripe to topics
    func subscripeToTopics() {
        // TODO 
        
        for (index, sectionTitle) in sectionTitles.enumerated() {
            for (jndex, notificationLabel) in notificationLabels[index].enumerated() {
                let topicName = "\(sectionTitle.replacingOccurrences(of: " ", with: ""))_\(notificationLabel.components(separatedBy: " ")[0])"
                if notificationStates[index][jndex] {
                    Messaging.messaging().subscribe(toTopic: topicName)
                } else {
                    Messaging.messaging().unsubscribe(fromTopic: topicName)
                }
            }
        }
    }
}
