//
//  TagsCell.swift
//  elmenusTask
//
//  Created by D-TAG on 1/25/20.
//  Copyright © 2020 elmenus. All rights reserved.
//

import UIKit
import Kingfisher

class TagsCell: UICollectionViewCell {

    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var tagNameLabel: UILabel!
    @IBOutlet weak var customView: CustomView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagNameLabel.adjustsFontSizeToFitWidth = true
        tagNameLabel.minimumScaleFactor = 0.5
    }
    
    func config(TagImageURL: String, TagName: String, selected: Bool) {
        if TagImageURL != "" {
            guard let ImageURL = URL(string: TagImageURL) else { return }
            self.tagImageView.kf.setImage(with: ImageURL)
        }
        let fullTagName = TagName.components(separatedBy: "-")
        self.tagNameLabel.text = TagName
        if selected {
            self.customView.borderWidth = 1
            self.customView.borderColor = .black
        } else {
            self.customView.borderWidth = 0
        }
    }

}
