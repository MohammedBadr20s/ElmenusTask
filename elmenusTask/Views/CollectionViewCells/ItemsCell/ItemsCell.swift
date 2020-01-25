//
//  ItemsCell.swift
//  elmenusTask
//
//  Created by D-TAG on 1/25/20.
//  Copyright © 2020 elmenus. All rights reserved.
//

import UIKit

class ItemsCell: UICollectionViewCell {

    
    @IBOutlet weak var ItemsImageView: UIImageView!
    @IBOutlet weak var ItemNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ItemNameLabel.adjustsFontSizeToFitWidth = true
        ItemNameLabel.minimumScaleFactor = 0.5
    }

    func config(ItemImageURL: String, ItemName: String) {
        if ItemImageURL != "" {
            guard let imageURL = URL(string: ItemImageURL) else { return }
            self.ItemsImageView.kf.setImage(with: imageURL)
        }
        self.ItemNameLabel.text = ItemName
    }
}
