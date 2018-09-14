//
//  Message.swift
//  WiFinder
//
//  Created by Boariu Andy on 9/14/18.
//  Copyright © 2018 Momentous Tech Corp. All rights reserved.
//

import Foundation
import UIKit

enum MessageSender {
    case bot, user
}

enum MessageType {
    case text, image
}

struct Message {
    var text: String?
    var image: UIImage?
    var sender = MessageSender.user
    var type = MessageType.text
    
    init(text: String?, image: UIImage?, sender: MessageSender, type: MessageType) {
        self.text = text
        self.image = image
        self.sender = sender
        self.type = type
    }
}
