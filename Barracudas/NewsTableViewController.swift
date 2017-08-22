//
//  NewsTableViewController.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 11.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {

    // MARK: Properties 
    
    let maxNumberOfArticles = 50
    var newsArticles: [NewsArticle] = []
    
    
    // MARK: Properties
    
    @IBOutlet weak var labelDownload: UILabel!
    @IBOutlet weak var activityIndicationDownload: UIActivityIndicatorView!
    @IBOutlet weak var viewTableFooter: UIView!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // add firebase listener to news table
        addFirebaseListener()
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArticles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get the current article 
        let article = newsArticles[indexPath.row]
        
        // build and configure the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        cell.ArticleCategory.text = article.category
        cell.ArticleTitle.text = article.heading
        cell.ArticlePreview.text = article.text
        cell.ArticleTimestamp.text = article.writtenByOnDate
        cell.ArticleImage.image = UIImage(named: "placeholderImg")
        
        // download image if available
        if let articleImgUrl = article.imgUrl {
            cell.ArticleActivityIndication.startAnimating()
            FirebaseClient.sharedInstance.downloadAnImage(imageUrl: articleImgUrl, completionHandler: { (image, error) in
                guard error == nil else {
                    // if image couldnt be downloaded just show placeholder, i.e. dont do anything
                    return
                }
                
                // else if the cell is still on screen update its image
                if cell == tableView.cellForRow(at: indexPath) {
                    self.performUIUpdatesOnMain {
                        cell.ArticleImage.image = image
                        cell.ArticleActivityIndication.stopAnimating()
                    }
                }
                
                // store the downloaded image in the articles array (for detail view of articles)
                self.newsArticles[indexPath.row].downloadedImg = image
            })
        }
        
        return cell
    }
    
    
    // MARK: - Table View methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        // build the article view controller
        let articleViewController: NewsArticleViewController
        articleViewController = storyboard?.instantiateViewController(withIdentifier: "ArticleViewController") as! NewsArticleViewController
        
        // inject selected article
        articleViewController.newsArticle = newsArticles[indexPath.row]
        
        self.navigationController!.pushViewController(articleViewController, animated: true)
    }
     
     
    // MARK: - Helpers

    func addFirebaseListener() {
        // add a listener to firebase database news table to download articles
        FirebaseClient.sharedInstance.registerNewsListener(toObserve: .childAdded, limit: maxNumberOfArticles) { (article) in
            // add most recent article at the top
            self.newsArticles.insert(article, at: 0)
            self.tableView.reloadData()
            
            // hide download indication
            self.viewTableFooter.isHidden = true
        }
        
        // add the connection state listener
        FirebaseClient.sharedInstance.registerConnectionStateListener { (state) in
            self.performUIUpdatesOnMain {
                self.tableView.tableHeaderView = state ? nil : OfflineIndicationLabel()
                self.setDownloadIndictation(isOnline: state)
            }
        }
    }
    
    func setDownloadIndictation(isOnline state: Bool) {
        labelDownload.text = state ? "downloading news ..." : "check your network connection"
        state ? activityIndicationDownload.startAnimating() : activityIndicationDownload.stopAnimating()
    }
}
