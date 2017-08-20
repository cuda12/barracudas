//
//  ContactTableViewController.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 20.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK: Actions

    @IBAction func sendEmail(_ sender: Any) {
         if let url = URL(string: "mailto:info@barracudas.ch") {
         UIApplication.shared.open(url)
         }
    }
    
    @IBAction func getDirectionsToBallpark(_ sender: Any) {
        if let url = URL(string: "https://maps.google.com/?q=47.4031,8.5959") {
            UIApplication.shared.open(url)
        }
    }
}
