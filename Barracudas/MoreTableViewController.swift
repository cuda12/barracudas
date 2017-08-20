//
//  MoreTableViewController.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 20.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: table view methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // only for social media section
        if indexPath.section == 1 {
            var appUrl: URL
            var webUrl: URL
            
            switch indexPath.row {
            case 0:
                appUrl = URL(string: "fb://page/?id=10479714786")!
                webUrl = URL(string: "https://facebook.com/BarracudasZH")!
            case 1:
                appUrl = URL(string: "instagram://user?username=zurichbarracudas")!
                webUrl = URL(string: "https://instagram.com/zurichbarracudas")!
            default:
                appUrl = URL(string: "twitter://user?screen_name=barracudaszh")!
                webUrl = URL(string: "https://twitter.com/barracudaszh")!
            }
            
            // if user has the app installed open link within app, otherwise open link in safari
            if UIApplication.shared.canOpenURL(appUrl) {
                UIApplication.shared.open(appUrl)
            } else {
                UIApplication.shared.open(webUrl)
            }
        }
    }
}
