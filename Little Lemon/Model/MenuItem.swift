//
//  MenuItem.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/29/24.
//

import Foundation

struct MenuItem: Decodable, CustomStringConvertible {
    
    static let sourceURL = URL(string: "https://www.w8wjb.com/littlelemon/menu-items.json")!

    
    let id: Int
    let title: String
    let image: String?
    let price: Double
    let desc: String
    let category: String
        
    var description: String { title }

    enum CodingKeys: CodingKey {
        case id
        case title
        case image
        case price
        case description
        case category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.price = try container.decode(Double.self, forKey: .price)
        self.desc = try container.decode(String.self, forKey: .description)
        self.category = try container.decode(String.self, forKey: .category)
    }

    
}
