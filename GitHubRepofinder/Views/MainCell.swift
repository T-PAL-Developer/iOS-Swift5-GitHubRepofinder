//
//  MainCell.swift
//  GitHubRepofinder
//
//  Created by Tomasz Paluszkiewicz on 10/12/2020.
//

import UIKit

class MainCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelStars: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelTitle.addTextSpacing(spacing: -0.41)
        labelStars.addTextSpacing(spacing: -0.41)
        cellView.layer.cornerRadius = cellView.frame.size.height / 5
        imageAvatar.layer.cornerRadius = imageAvatar.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
