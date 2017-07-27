
//
//  SBSFClient.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 23.07.17.
//  In accordance with the TMDBClient from Jarrod Parkes
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import Foundation

// MARK: - SBSFClient

class SBSFClient: NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // TODO config
    
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGETMethod(_ method: String, parameters: [String: AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        // build url with parameters (e.g. filters)
        // TODO
        let baseUrl = URL(string: API.baseUrl + Methods.Standings)!
        
        // configure the request
        let request = URLRequest(url: baseUrl)
        
        // make the request
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // TODO prober handle of errors 
            
            // check error
            guard (error == nil) else {
                print("there was an error in the request to spielplan \(error!)")
                completionHandlerForGET(nil, error! as NSError)
                return
            }
            
            // tODO check response
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Status code not 2xx!)")
                completionHandlerForGET(nil, nil)
                return
            }
            
            guard let data = data else {
                print("no data was returned")
                completionHandlerForGET(nil, nil)
                return
            }
            
            // parse the data and send it to the completion handler
            self.convertJsonToDict(data: data, withCompletionHandler: completionHandlerForGET)
        }
        
        // start the request
        task.resume()
        
        return task
    }
    
    
    // MARK: Convinience Methods (TODO move separate extension?)
    
    func getStandings(_ completionHanlder: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let parameters = [String: AnyObject]()
        
        
        // TODO maybe do some postprocessing parsing here
        _ = taskForGETMethod(Methods.Standings, parameters: parameters, completionHandlerForGET: completionHanlder)
        
    }
    
    
    // MARK: Helpers
    
    func convertJsonToDict(data: Data, withCompletionHandler completionHandler: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
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

extension SBSFClient {
    
    struct API {
        
        static let baseUrl = "http://www.spielplan.ch/api/"
    
    }
    
    struct Methods {
        
        static let Games = "games/"
        static let Standings = "standings/"
        
    }
}
