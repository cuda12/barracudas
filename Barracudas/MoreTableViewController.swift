//
//  MoreTableViewController.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 20.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    // only for social media section
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            print("open social medias")
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
