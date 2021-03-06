//
//  FirebaseClient.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 01.08.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//
//  based on Udacity lesson "Firebase over the weekend"
//

import Foundation
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI


class FirebaseClient {
    
    // MARK: Shared Instance
    
    static let sharedInstance = FirebaseClient()
    
    
    // MARK: Properties
    
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    fileprivate var _refHandle: DatabaseHandle!
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    
    var isSignedIn: Bool = false
    
    
    // MARK: Initializer
    
    init() {
        // configure Firebase Auth, Database and Storage
        configureAuth()
        configureDatabase()
        configureStorage()
    }
    
    
    // MARK: Config
    
    func configureAuth() {
        // configure firebase authentication (add google to providers)
        let provider: [FUIAuthProvider] = [FUIGoogleAuth()]
        FUIAuth.defaultAuthUI()?.providers = provider
    }
    
    func configureDatabase() {
        // configure firebase realtime database
        Database.database().isPersistenceEnabled = true
        ref = Database.database().reference()
        
    }
    
    func configureStorage() {
        // configure firebase storage
        storageRef = Storage.storage().reference()
    }
    
    deinit {
        // set up what needs to be deinitialized when client is no longer used
        
        // remove auth handle
        Auth.auth().removeStateDidChangeListener(_authHandle)
        
        // remove all listeners
        ref.removeAllObservers()
    }
    
    
    // MARK: Handles and Listeners
    
    func registerNewsListener(toObserve eventAction: DataEventType, limit: Int, completionHandler: @escaping (_ article: NewsArticle) -> Void) {
        // add a listener to the news feed table for the given action
        
        _refHandle = ref.child(Constants.FirebaseTables.News).queryLimited(toLast: UInt(limit)).observe(eventAction, with: { (snapshot: DataSnapshot) in
            completionHandler(NewsArticle(withSnapshot: snapshot))
        })
    }
    
    func registerRosterListener(toObserve eventAction: DataEventType, forTeam team: String, completionHandler: @escaping (_ player: PlayersDetails) -> Void) {
        // add a listener to the rosters table for the given action
        
        _refHandle = ref.child(Constants.FirebaseTables.Rosters + "/" + team).observe(eventAction, with: { (snapshot: DataSnapshot) in
            completionHandler(PlayersDetails(withSnapshot: snapshot))
        })
    }
    
    func registerGamedayListener(toObserve eventAction: DataEventType, forDate dateString: String, completionHandler: @escaping( _ game: GameDetails) -> Void) {
        // add a listener to the gameday table for the given action and day
        
        _refHandle = ref.child(Constants.FirebaseTables.Gamedays + "/" + dateString).observe(eventAction, with: { (snapshot: DataSnapshot) in
            completionHandler(GameDetails(withSnapshot: snapshot))
        })
    }
    

    func registerAuthListener(completionHandler: @escaping (_ isSignedIn: Bool, _ user: User?) -> Void) {
        // add a listener to the auth handle
        
        _authHandle = Auth.auth().addStateDidChangeListener({ (auth: Auth, user: User?) in
            if let user = user {
                self.isSignedIn = true
                completionHandler(true, user)
            } else {
                self.isSignedIn = false
                completionHandler(false, nil)
            }
        })
    }
    
    func registerGamedaysSingleObservation(completionHandler: @escaping ( _ dates: [String]?) -> Void) {
        // retrieve array of all gamedays once
        
        ref.child(Constants.FirebaseTables.GamedaysAll).observeSingleEvent(of: .value, with: { (snapshot) in
            if let values = snapshot.value as? [String] {
                completionHandler(values)
            } else {
                completionHandler(nil)
            }
        })
    }
    
    func registerConnectionStateListener(completionHanlder: @escaping (_ isConnected: Bool) -> Void) {
        // detecting connection state
        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { (snapshot) in
            completionHanlder(snapshot.value as? Bool ?? false)
        })
    }
    
    // MARK: download images
    
    func downloadAnImage(imageUrl: String, completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        // download the image from the firebase Storage
        
        Storage.storage().reference(forURL: imageUrl).getData(maxSize: INT64_MAX, completion: { (data, error) in
            guard error == nil else {
                completionHandler(nil, error!)
                return
            }
            
            let image = UIImage.init(data: data!)
            completionHandler(image, nil)
        })
    }
    
    
    // MARK: Auth methods
    
    func authViewController() -> UINavigationController {
        let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
        return authViewController
    }
    
    func signOut(completionHandler: @escaping (_ success: Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completionHandler(true)
        } catch {
            completionHandler(false)
        }
    }
    
    
    // MARK: update methods
   
    func updateGameDetails(for gameDetails: GameDetails, onGameday gameDay: String ) {
        // build basepath
        let basePath = Constants.FirebaseTables.Gamedays + "/\(gameDay)/\(gameDetails.snapshotKey)/"

        // loop over all set values
        for (key, value) in gameDetails.asDict() {
             ref.child(basePath + key).setValue(value)
        }
    }
}


// MARK: - FirebaseClient Constants

extension FirebaseClient {
    
    struct Constants {
        
        // MARK: Database tables
        
        struct FirebaseTables {
            static let News = "news"
            static let Rosters = "rosters"
            static let Gamedays = "gamedays"
            static let GamedaysAll = "all_gamedays"
        }
        
        
        // MARK: News Table Keys
        
        struct NewsResponseKeys {
            static let Category = "section_category"
            static let Heading = "article_heading"
            static let Text = "article_text"
            static let ImageUrl = "image_url"
            static let Timestamp = "timestamp"
            static let PostedBy = "posted_by"
        }
        
        
        // MARK: Roster Table Keys
        
        struct RosterResponseKeys {
            static let FirstName = "first_name"
            static let LastName = "last_name"
            static let Number = "number"
            static let Position = "position"
            static let AdditionalPosition = "additional_position"
            static let ImageUrl = "image_url"
        }
        
        
        // MARK: Games Table Keys
        
        struct GameResponseKeys {
            static let Inning = "inning"
            static let InningIsTop = "inning_is_top"
            static let Outs = "outs"
            static let League = "league"
            static let Runners = "runners"
            static let Score = "score"
            static let State = "state"
            static let Teams = "teams"
            static let Time = "time"
        }
        
        
        // MARK: Games States and DateFormat
        
        struct GameStates {
            static let live = "live"
            static let notStarted = "notStarted"
            static let final = "final"
        }
        
        struct GameDays {
            static let DateFormat = "yyyyMMdd"
        }
    }
}
