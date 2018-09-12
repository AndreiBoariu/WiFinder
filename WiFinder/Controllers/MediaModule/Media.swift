//
//  Media.swift
//  WiFinder
//
//  Created by Boariu Andy on 9/12/18.
//  Copyright © 2018 Momentous Tech Corp. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Media {
    var artistName: String?
    var artwork: String?
    var trackName: String?
    var longDescription: String?
    var type: String?
    
    init(json: JSON) {
        
    }
}
