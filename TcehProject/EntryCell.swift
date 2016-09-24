//
//  EntryCell.swift
//  TcehProject
//
//  Created by Yaroslav Smirnov on 07/09/2016.
//  Copyright © 2016 Yaroslav Smirnov. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {

    @IBOutlet weak var labelAmount: UILabel!

    @IBOutlet weak var labelCategory: UILabel!
    
    @IBOutlet weak var labelDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
