//
//  TagsModel.swift
//  elmenusTask
//
//  Created by D-TAG on 1/25/20.
//  Copyright © 2020 elmenus. All rights reserved.
//

import Foundation


// MARK: - TagsModel
struct TagsModel: Codable {
    var tags: [Tag]?
}

// MARK: - Tag
struct Tag: Codable {
    var tagName: String?
    var photoURL: String?
    var selected: Bool?
}
