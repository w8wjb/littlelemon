//
//  LineItem+CoreDataProperties.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/31/24.
//
//

import Foundation
import CoreData


extension LineItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LineItem> {
        return NSFetchRequest<LineItem>(entityName: "LineItem")
    }

    @NSManaged public var quantity: Int16
    @NSManaged public var toDish: Dish?

}

extension LineItem : Identifiable {

}
