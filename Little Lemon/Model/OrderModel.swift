//
//  OrderModel.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/31/24.
//

import Foundation
import CoreData

@MainActor
class OrderModel: ObservableObject {
    
    func addDish(_ dish: Dish, quantity: Int, inContext context: NSManagedObjectContext) throws {
        
        let fetchRequest = LineItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "toDish ==  %@", dish)
        
        let result = try context.fetch(fetchRequest)
        
        if let lineItem = result.first {
            lineItem.quantity += Int16(quantity)
            
        } else {
            
            let lineItem = LineItem(context: context)
            lineItem.toDish = dish
            lineItem.quantity = Int16(quantity)
            
        }
        
    }
    
    
}
