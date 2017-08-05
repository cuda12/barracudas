//
//  NewsArticle.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 01.08.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import Foundation
import Firebase

struct NewsArticle {
    
    // MARK: Properties
    
    let snapshotKey: String
    let category: String
    let heading: String
    let text: String
    let imgUrl: String?
    let creationDateSince1970: Double
    let postedBy: String
    
    var writtenByOnDate: String {
        get {
            return "\(postedBy) | \(convertIntoDateString(dateSince1970: creationDateSince1970))"
        }
    }
    
    var downloadedImg: UIImage?
    
    
    // MARK: Initializer method
    
    init(withSnapshot snapshot: DataSnapshot) {
        
        // store snapshotkey
        snapshotKey = snapshot.key
        
        // parse json dict to corresponding properties
        let dataDict = snapshot.value as! [String: AnyObject]
        
        category = dataDict[FirebaseClient.Constants.NewsResponseKeys.Category] as? String ?? "CLUB"
        heading = dataDict[FirebaseClient.Constants.NewsResponseKeys.Heading] as? String ?? "TITLE"
        text = dataDict[FirebaseClient.Constants.NewsResponseKeys.Text] as? String ?? "TEXT"
        imgUrl = dataDict[FirebaseClient.Constants.NewsResponseKeys.ImageUrl] as? String ?? "noImageUrl"
        creationDateSince1970 = (dataDict[FirebaseClient.Constants.NewsResponseKeys.Timestamp] as? Double)!
        postedBy = dataDict[FirebaseClient.Constants.NewsResponseKeys.PostedBy] as? String ?? "bar"
        
        // init downloadedImg to nil
        downloadedImg = nil
    }
}

// MARK: date convertion and formatter method

extension NewsArticle {
    
    func convertIntoDateString(dateSince1970: Double) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.locale = Locale.current
        
        return dateFormatter.string(from: Date(timeIntervalSince1970: dateSince1970))
    }
}
