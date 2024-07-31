//
//  Dish+CoreDataProperties.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/30/24.
//
//

import Foundation
import CoreData
import os

extension Dish {
    
    static public func countAll(inContext context: NSManagedObjectContext) throws -> Int {
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        fetchRequest.predicate = NSPredicate(value: true)
        
        return try context.count(for: fetchRequest)
    }

    static public func exists(withTitle title: String, inContext context: NSManagedObjectContext) throws -> Bool {
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        let count = try context.count(for: fetchRequest)
        return count > 0
    }

    static func removeAll(inContext context: NSManagedObjectContext) throws {
        // Delete all dishes from the store
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity().name!)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        let deleteResult = try context.execute(deleteRequest) as? NSBatchDeleteResult
        
        guard let deletedIDs = deleteResult?.result as? [NSManagedObjectID] else {
            return
        }
        
        let deletedObjects: [AnyHashable: Any] = [
            NSDeletedObjectsKey: deletedIDs
        ]
        
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: deletedObjects, into: [context])
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dish> {
        return NSFetchRequest<Dish>(entityName: "Dish")
    }
    
    
    @NSManaged public var title: String?
    @NSManaged public var image: String?
    @NSManaged public var price: Double
    @NSManaged public var desc: String?
    @NSManaged public var category: String?
    

}

extension Dish : Identifiable {

}
