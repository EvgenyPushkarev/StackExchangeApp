//
//  UsersTableViewCell.swift
//  AlTab
//
//  Created by MAC on 18.05.2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var answerscountLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBAction func touchCell(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
