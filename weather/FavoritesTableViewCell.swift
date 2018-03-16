//
//  FavoritesTableViewCell.swift
//  weather
//
//  Created by Mimi Lundberg on 2018-03-15.
//  Copyright © 2018 Mimi Lundberg. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
