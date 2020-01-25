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
        //MARK:- if you want to use only the name of tag you can use fullTagName[1].trim() instead of tag name
        self.tagNameLabel.text = TagName
        if selected {
            self.customView.borderWidth = 1
            self.customView.borderColor = #colorLiteral(red: 0.8980392157, green: 0.3254901961, blue: 0.231372549, alpha: 1)
        } else {
            self.customView.borderWidth = 0
        }
    }

}
