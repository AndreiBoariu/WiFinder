//
//  MediaCell.swift
//  WiFinder
//
//  Created by Boariu Andy on 9/12/18.
//  Copyright © 2018 Momentous Tech Corp. All rights reserved.
//

import UIKit
import Kingfisher

class MediaCell: UITableViewCell {

    static let cellID = "MediaCell_ID"
    
    @IBOutlet weak var imgvMedia: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Custom Methods
    func loadMedia(curMedia: Media) {
        if let strArtwork = curMedia.artwork {
            imgvMedia.kf.setImage(
                with: URL(string: strArtwork),
                placeholder: nil,
                options: [.transition(ImageTransition.fade(1))]
            )
        }
        
        if let type = curMedia.type {
            switch type {
            case MediaType.music.rawValue:
                lblName.text = curMedia.trackName
                lblDescription.text = curMedia.artistName
                
            case MediaType.tvShow.rawValue:
                lblName.text = curMedia.artistName
                lblDescription.text = curMedia.longDescription
                
            case MediaType.movie.rawValue:
                lblName.text = curMedia.trackName
                lblDescription.text = curMedia.longDescription
                
            default:
                break
            }
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func btnBounceImageViewAction(_ sender: UIButton) {
        imgvMedia.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.imgvMedia.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1)
        }, completion: { finished in
            UIView.animate(withDuration: 0.3, animations: {
                self.imgvMedia.layer.transform = CATransform3DMakeScale(1, 1, 1) })
        })
    }
}

