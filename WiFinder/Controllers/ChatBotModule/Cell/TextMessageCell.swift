//
//  TextMessageCell.swift
//  WiFinder
//
//  Created by Boariu Andy on 9/14/18.
//  Copyright © 2018 Momentous Tech Corp. All rights reserved.
//

import UIKit

class TextMessageCell: UITableViewCell {

    static let cellID = "TextMessageCell_ID"
    
    @IBOutlet weak private var constLabelLeft: NSLayoutConstraint!
    @IBOutlet weak private var constLabelRight: NSLayoutConstraint!
    
    @IBOutlet weak var lblMessageText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Custom Methods
    
    func loadMessage(_ message: Message) {
        lblMessageText.text = message.text
        
        if message.sender == .user {
            constLabelRight.constant = 8.0
            constLabelLeft.constant = self.frame.width - lblMessageText.frame.size.width - 8
            
            lblMessageText.textAlignment = .right
        }
        else {
            constLabelRight.constant = self.frame.width - lblMessageText.frame.size.width - 8
            constLabelLeft.constant = 8.0
            
            lblMessageText.textAlignment = .left
        }
    }

}
