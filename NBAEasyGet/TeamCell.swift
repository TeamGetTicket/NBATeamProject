//
//  TeamCell.swift
//  NBAEasyGet
//
//  Created by paul on 10/17/18.
//  Copyright © 2018 PoHung Wang. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell {
    
    
    @IBOutlet weak var teamNameLabel: UILabel!
    
    @IBOutlet weak var teamAliasLabel: UILabel!
    
    @IBOutlet weak var teamVenueLabel: UILabel!
    @IBOutlet weak var teamAddressLabel: UILabel!
    
    @IBOutlet weak var teamImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
