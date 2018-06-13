//
//  AutoCompleteAddressTableViewCell.swift
//  GoogleMap
//
//  Created by Gavin Ong on 13/6/18.
//  Copyright © 2018 Gavin Ong. All rights reserved.
//

import UIKit


class AutoCompleteAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var resultAddressLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
