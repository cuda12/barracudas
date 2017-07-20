//
//  ContactTableViewController.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 20.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func sendEmail(_ sender: Any) {
         print("test mail")
         if let url = URL(string: "mailto:info@barracudas.ch") {
         print(url)
         UIApplication.shared.open(url)
         }
    }
    
    @IBAction func getDirectionsToBallpark(_ sender: Any) {
        if let url = URL(string: "https://maps.google.com/?q=47.4031,8.5959") {
            print(url)
            UIApplication.shared.open(url)
        }
    }
}
