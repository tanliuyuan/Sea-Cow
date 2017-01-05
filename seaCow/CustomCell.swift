//
//  CustomCell.swift
//  seaCow
//
//  Created by Tim Van Horn on 5/4/15.
//  Copyright (c) 2015 Scott G Gavin. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var gradient: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
