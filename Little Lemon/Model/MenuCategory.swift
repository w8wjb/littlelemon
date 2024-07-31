//
//  MenuCategory.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/31/24.
//

import Foundation

enum MenuCategory: String, Identifiable, CaseIterable, CustomStringConvertible {
    case starters
    case mains
    case desserts
    case drinks
    
    var id: MenuCategory { self }
    
    var description: String {
        switch self {
        case .starters: "Starters"
        case .mains: "Mains"
        case .desserts: "Desserts"
        case .drinks: "Drinks"
        }
    }
    
}
