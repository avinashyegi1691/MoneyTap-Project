//
//  CoreDataStack.swift
//  consumer
//
//  Created by Ashwin Kini on 21/12/16.
//  Copyright © 2016 HBBrands. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack: NSObject {
    
    static let sharedInstance = CoreDataStack()
    
     func getContext () -> NSManagedObjectContext {
        return  managedObjectContext
    }

    //MARK :- Core Data stack properties
    lazy var applicationsDocumentDirectory:NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1] as NSURL
    }()
    
    lazy var managedObjectContext:NSManagedObjectContext = {
        let coordinator = self.persistentCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var persistentCoordinator:NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel:self.managedObjectModel)
        let url : URL?
        url = self.applicationsDocumentDirectory.appendingPathComponent("Assignment.sqlite")
        var failureReason = "There was an error in loading or saving application data"
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at:url, options:[NSInferMappingModelAutomaticallyOption: true, NSMigratePersistentStoresAutomaticallyOption:true])
        }
        catch{
            
            var dict = [String:AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize applictaions saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error as NSError
            
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectModel:NSManagedObjectModel = {
        let modelURL = Bundle.main.path(forResource: "Assignment", ofType: "momd")
        return NSManagedObjectModel(contentsOf:NSURL(string:modelURL!)! as URL)!
    }()
    
    func saveContext() {

        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            }catch{
                let unresolvedError = error as NSError
                NSLog("Unresolved error \(unresolvedError), \(unresolvedError.userInfo)")
            }
        }
    }
}
