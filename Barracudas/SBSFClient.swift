
//
//  SBSFClient.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 23.07.17.
//  In accordance with the TMDBClient from Jarrod Parkes
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import Foundation
import UIKit
import CoreData


// MARK: - SBSFClient

class SBSFClient: NSObject {
    
    // MARK: Properties
    
    let stack = (UIApplication.shared.delegate as! AppDelegate).stack
    var session = URLSession.shared
    
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    
    // MARK: GET method
    
    func taskForGETMethod(_ method: String, completionHandlerForGET: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        // build url with with given method
        let baseUrl = URL(string: API.baseUrl + method)!
        
        // configure the request
        let request = URLRequest(url: baseUrl)
        
        // make the request
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // check requesting data didnt fail (i.e. an error occured, an invalid response status code or no data was returned)
            guard (error == nil) else {
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: [NSLocalizedDescriptionKey: error!]))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: [NSLocalizedDescriptionKey: "invalid status Code"]))
                return
            }
            
            guard let data = data else {
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: [NSLocalizedDescriptionKey: "no data found"]))
                return
            }
            
            // parse the data and send it to the completion handler
            self.convertJsonToDict(data: data, withCompletionHandler: completionHandlerForGET)
        }
        
        // start the request
        task.resume()
        return task
    }
    
    
    // MARK: Convenience Methods
    
    func getStandings(_ completionHanlder: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        // downloads standings and updates core data model
        
        _ = self.taskForGETMethod(Methods.Standings, completionHandlerForGET: { (result, error) in
            guard (error == nil) else {
                completionHanlder(false, error!)
                return
            }
            
            // remove previous loaded standings (in case a team switches league, the complete db is dropped an reloaded)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TeamsStandings")
            if let result = try? self.stack.context.fetch(fetchRequest) {
                for object in result {
                    self.stack.context.delete(object as! NSManagedObject)
                }
            }
            
            // for each Barracudas team update the standings of its league from the downloaded data
            for teamDetail in TeamDetails.allTeams {
                if let detailsPerLeague = result?[teamDetail.dbKey] as? [[String:AnyObject]] {
                    
                    // add records for each team in the league to the model (local database)
                    for teamDetailsPerLeague in detailsPerLeague {
                        _ = TeamsStandings(league: teamDetail.abbrTeamName, recordDetails: teamDetailsPerLeague, context: self.stack.context)
                    }
                }
            }
            
            // save downloaded data
            self.stack.save()
            
            // call completion handler
            completionHanlder(true, nil)
        })
    }
    
    
    // MARK: Helpers
    
    func convertJsonToDict(data: Data, withCompletionHandler completionHandler: (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) {
        
        var parsedResult: [String:AnyObject]! = nil
        do {
            let parsedResultData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSArray
            // Data dictionary is wrapped in an array with one element
            parsedResult = parsedResultData[0] as! [String : AnyObject]
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON"]
            completionHandler(nil, NSError(domain: "convertData", code: 1, userInfo: userInfo))
        }
        
        completionHandler(parsedResult, nil)
    }
    
    
    // MARK: shared instance
    
    class func sharedInstance() -> SBSFClient {
        struct Singleton {
            static var sharedInstance = SBSFClient()
        }
        
        return Singleton.sharedInstance
    }
}


// MARK: - Constants extension

extension SBSFClient {
    
    struct API {
        static let baseUrl = "http://www.spielplan.ch/api/"
    }
    
    struct Methods {
        static let Games = "games/"
        static let Standings = "standings/"
    }
}
