//
//  ItemsModel.swift
//  elmenusTask
//
//  Created by D-TAG on 1/25/20.
//  Copyright © 2020 elmenus. All rights reserved.
//

import Foundation


// MARK: - ItemsModel
struct ItemsModel: Codable {
    var items: [Item]?
}

// MARK: - Item
struct Item: Codable {
    var id: Int?
    var name: String?
    var photoURL: String?
    var itemDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case photoURL = "photoUrl"
        case itemDescription = "description"
    }
}
