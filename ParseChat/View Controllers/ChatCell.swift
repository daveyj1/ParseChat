//
//  ChatCell.swift
//  ParseChat
//
//  Created by Joseph Davey on 2/2/18.
//  Copyright © 2018 Joseph Davey. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.layer.cornerRadius = 16
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        messageLabel.layer.cornerRadius = 16
        // Configure the view for the selected state
    }

}
