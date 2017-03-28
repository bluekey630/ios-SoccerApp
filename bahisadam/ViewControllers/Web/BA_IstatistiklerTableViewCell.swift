//
//  BA_IstatistiklerTableViewCell.swift
//  bahisadam
//
//  Created by bluekey on 3/25/17.
//  Copyright © 2017 ilkerozcan. All rights reserved.
//

import UIKit

class BA_IstatistiklerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerImage: UIImageView!
   
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    
    @IBOutlet weak var teamName: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
}
