//
//  NSManagedObject.swift
//  SearchAndStoreDemo
//
//  Created by Avinash on 11/07/18.
//  Copyright © 2018 Avinash. All rights reserved.
//

import Foundation
import CoreData

let context = CoreDataStack.sharedInstance.managedObjectContext

extension NSManagedObject {
    
    class func createLocalModel() -> NSManagedObject {
        let className = String(describing: self)
        let entityDescription = NSEntityDescription.entity(forEntityName: className, in: context)
        let localModel = NSManagedObject(entity: entityDescription!, insertInto: context)
        
        return localModel
    }

    func deleteModel() {
        context.delete(self)
    }
    
    func saveModel() {
        if context.hasChanges {
            do {
               try context.save()
            } catch {
                print("Failed to save")
            }
        }
    }

    class func fetchAllObjects(predicate: NSPredicate?) -> [NSManagedObject]{
        var results = [NSManagedObject]()
        let entityName = String(describing: self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate

        do {
            results = (try context.fetch(fetchRequest) as? [NSManagedObject])!
        }
        catch {
            print("Failed to fetch")
        }
        return results
    }
}
