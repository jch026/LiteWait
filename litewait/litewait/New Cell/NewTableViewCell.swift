//
//  NewTableViewCell.swift
//  litewait
//
//  Created by Joseph Ho on 10/4/18.
//  Copyright © 2018 dumplingNinjas. All rights reserved.
//

import UIKit

class NewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageContainer: UIImageView!
    @IBOutlet weak var RestaurantLabel: UILabel!
    @IBOutlet weak var WaitTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
