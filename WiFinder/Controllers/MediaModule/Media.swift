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
    var previewUrl: String?
    
    init(json: JSON) {
        artistName = json["artistName"].string
        artwork = json["artworkUrl100"].string
        trackName = json["trackName"].string
        longDescription = json["longDescription"].string
        previewUrl = json["previewUrl"].string
    }
}
