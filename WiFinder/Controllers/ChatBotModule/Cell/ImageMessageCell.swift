//
//  ImageMessageCell.swift
//  WiFinder
//
//  Created by Boariu Andy on 9/14/18.
//  Copyright © 2018 Momentous Tech Corp. All rights reserved.
//

import UIKit

class ImageMessageCell: UITableViewCell {
    
    static let cellID = "ImageMessageCell_ID"

    @IBOutlet weak private var constImageLeft: NSLayoutConstraint!
    @IBOutlet weak private var constImageRight: NSLayoutConstraint!
    
    @IBOutlet weak var imgvMessageImage: UIImageView!
    
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
        imgvMessageImage.image = message.image
        
        if message.sender == .user {
            constImageRight.constant = 8.0
            constImageLeft.constant = self.frame.width - imgvMessageImage.frame.width - 8
        }
        else {
            constImageLeft.constant = 8.0
            constImageRight.constant = self.frame.width - imgvMessageImage.frame.width - 8
        }
        
        
    }
}
