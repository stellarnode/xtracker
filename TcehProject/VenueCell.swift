//
//  VenueCell.swift
//  TcehProject
//
//  Created by Yaroslav Smirnov on 06/09/2016.
//  Copyright © 2016 Yaroslav Smirnov. All rights reserved.
//

import UIKit

class VenueCell: UITableViewCell {

    @IBOutlet weak var labelVenue: UILabel!

    @IBOutlet weak var labelDistance: UILabel!

    @IBOutlet weak var imageCategory: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
