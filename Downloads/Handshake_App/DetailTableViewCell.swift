//
//  DetailTableViewCell.swift
//  Handshake
//
//  Created by Bhandari, Ishdeep on 4/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var DetailTitle: UILabel!
    
    @IBOutlet weak var DetailSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //DetailSubtitle.textAlignment = NSTextAlignment.Left
        DetailSubtitle.numberOfLines = 0
        DetailSubtitle.sizeToFit()
        DetailSubtitle.preferredMaxLayoutWidth = 320
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
