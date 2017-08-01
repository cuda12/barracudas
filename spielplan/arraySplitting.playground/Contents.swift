//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


let team1 = ["team": "bar", "wins": 5, "group": "east"] as [String: AnyObject]
let team2 = ["team": "arb", "wins": 2, "group": "east"] as [String: AnyObject]
let team3 = ["team": "bbb", "wins": 3, "group": "east"] as [String: AnyObject]
let team4 = ["team": "ccc", "wins": 5, "group": "west"] as [String: AnyObject]
let team5 = ["team": "ddd", "wins": 1, "group": "west"] as [String: AnyObject]
let team6 = ["team": "eee", "wins": 100, "group": "west"] as [String: AnyObject]

let standings = [team1, team2, team3, team4, team5, team6]
print(standings)

print(team1.count)

// split with knowing group names

let standingsWest = standings.split { (team) -> Bool in
    if team["group"] as! String == "west" {
        return true
    } else {
        return false
    }
}
print(standingsWest)


// extract groups

var groups = [String]()

for team in standings {
    if let groupName = team["group"] as? String {
        if !groups.contains(groupName) {
            groups.append(groupName)
        }
    }
}


// try to split in one loop

struct Group {
    let name: String
    var teams: [[String: AnyObject]]
    
    var teamsRanked : [[String: AnyObject]] {
        get {
            return teams.sorted(by: { $0["wins"] as! Int > $1["wins"] as! Int })
        }
    }
}

var standingsByGroup = [Group]()
for team in standings {
    if let groupName = team["group"] as? String {
        if let index = standingsByGroup.index(where: { $0.name == groupName } ){
            standingsByGroup[index].teams.append(team)
        } else {
            standingsByGroup.append(Group(name: groupName, teams: [team]))
        }
    }
}

print(standingsByGroup[1].teamsRanked)


// with an extra struct

struct Standings {
    let leagueName: String
    let teams: [[String: AnyObject]]
    
    var byGroups: [Group] {
        get {
            var standingsByGroup = [Group]()
            for team in teams {
                if let groupName = team["group"] as? String {
                    if let index = standingsByGroup.index(where: { $0.name == groupName } ){
                        standingsByGroup[index].teams.append(team)
                    } else {
                        standingsByGroup.append(Group(name: groupName, teams: [team]))
                    }
                }
            }
            return standingsByGroup
        }
    }
}

let standingsNLA = Standings(leagueName: "NLA", teams: standings)

print(standingsNLA.byGroups[0].teamsRanked)
print(standingsNLA.byGroups.count)
print(standingsNLA.byGroups[1].teams.count)



// MARK: string splitting

let streakStringOrg = "Won 12"
let streakStringOrg2 = "Lost 12"

func convertStreakToAbbr(streak: String) -> String {
    let strComp = streak.components(separatedBy: " ")
    return strComp[0].substring(to: streak.index(streak.startIndex, offsetBy: 1)) + strComp[1]
}

print(convertStreakToAbbr(streak: streakStringOrg) + " / " + convertStreakToAbbr(streak: streakStringOrg2))


Date().timeIntervalSince1970




