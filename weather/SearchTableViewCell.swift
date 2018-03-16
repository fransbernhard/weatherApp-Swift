//
//  SearchTableViewCell.swift
//  weather
//
//  Created by Mimi Lundberg on 2018-03-16.
//  Copyright © 2018 Mimi Lundberg. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sCellLabel: UILabel!
    @IBOutlet weak var sCellImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
