//
//  NewsTableViewCell.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 11.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ArticleTimestamp: UILabel!
    @IBOutlet weak var ArticleCategory: UILabel!
    @IBOutlet weak var ArticleTitle: UILabel!
    @IBOutlet weak var ArticleImage: UIImageView!
    @IBOutlet weak var ArticlePreview: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
