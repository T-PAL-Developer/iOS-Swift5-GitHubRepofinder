//
//  DetailsCell.swift
//  GitHubRepofinder
//
//  Created by Tomasz Paluszkiewicz on 11/12/2020.
//

import UIKit

class DetailsCell: UITableViewCell {

   
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var numberBackground: UIView!
    @IBOutlet weak var labelCommitAuthor: UILabel!
    @IBOutlet weak var labelEmailAuthor: UILabel!
    @IBOutlet weak var labelCommitMessage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       numberBackground.layer.cornerRadius = numberBackground.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
