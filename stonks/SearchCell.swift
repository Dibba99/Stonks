//
//  SearchCell.swift
//  stonks
//
//  Created by Cosmo on 5/1/21.
//

import UIKit

class SearchCell: UITableViewCell {
    
    
    @IBOutlet weak var posterView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var publishedLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}