//
//  NewsTableViewController.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 11.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {

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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        
        // Configure the cell...
        cell.ArticleCategory.text = "NLA"
        cell.ArticleTitle.text = "Cudas beat the Challis in a nailbiter"
        cell.ArticlePreview.text = "some long text"
        cell.ArticleTimestamp.text = "aru | today, 12:12"
        cell.ArticleImage.image = UIImage(named: "5947f7a1c009d")

        return cell
    }
    
    
    // MARK: - Table View methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get selected article
        // TODO
        
        // build the article view controller
        let articleViewController: NewsArticleViewController
        articleViewController = storyboard?.instantiateViewController(withIdentifier: "ArticleViewController") as! NewsArticleViewController
        
        // TODO inject article here
        
        self.navigationController!.pushViewController(articleViewController, animated: true)
    }
    
    
    
    /*
     
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
