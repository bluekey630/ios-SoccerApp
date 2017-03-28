//
//  BA_FiksturTableViewCell.swift
//  bahisadam
//
//  Created by bluekey on 3/25/17.
//  Copyright © 2017 ilkerozcan. All rights reserved.
//

import UIKit

class BA_FiksturTableViewCell: UITableViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var teamImage1: UIImageView!
    @IBOutlet weak var teamName1: UILabel!
    @IBOutlet weak var teamImage2: UIImageView!
    @IBOutlet weak var teamName2: UILabel!
    
    @IBOutlet weak var infoConstrain: NSLayoutConstraint!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
}
