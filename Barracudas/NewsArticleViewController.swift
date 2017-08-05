//
//  NewsArticleViewController.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 11.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class NewsArticleViewController: UIViewController {

    // MARK: Porperties
    var newsArticle: NewsArticle!
    
    // MARK: Outlets
    
    @IBOutlet weak var articleSection: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleDate: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleText: UILabel!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load content of article
        articleSection.text = newsArticle.category
        articleTitle.text = newsArticle.heading
        articleDate.text = newsArticle.writtenByOnDate
        articleText.text = newsArticle.text
        
        // if image was already downloaded display it, otherwise show a place holder image and download the image
        if let downloadedImg = newsArticle.downloadedImg {
            articleImage.image = downloadedImg
        } else {
            articleImage.image = UIImage(named: "placeholderImg")
            if let imageUrl = newsArticle.imgUrl {
                FirebaseClient.sharedInstance.downloadAnImage(imageUrl: imageUrl, completionHandler: { (image, error) in
                    if let image = image {
                        self.performUIUpdatesOnMain {
                            self.articleImage.image = image
                        }
                    }
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
