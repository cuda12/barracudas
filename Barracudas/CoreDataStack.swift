//
//  CoreDataStack.swift
//  VirtualTourist
//
//  Created by Andreas Rueesch on 05.03.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//
//  in accordance to the Udacity CoreDataStack struct written by Fernadnod Rodriguez Romero
//

import CoreData

struct CoreDataStack {
    
    
    // MARK:  - Properties
    
    private let model: NSManagedObjectModel
    internal let coordinator: NSPersistentStoreCoordinator
    private let modelUrl: URL
    internal let dbUrl: URL
    internal let persistingContext: NSManagedObjectContext
    let context: NSManagedObjectContext
    
    
    // MARK:  - Initializers
    
    init?(modelName: String) {
        
        // assume the model is in the main bundle 
        guard let modelUrl = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            fatalError("unable to find \(modelName) in the main bundle")
            return nil
        }
        self.modelUrl = modelUrl
        
        // create a model from the url
        guard let model = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("unable to create a model from \(modelUrl)")
            return nil
        }
        self.model = model
        
        // create the store coordinater
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        // create the contexts and connect them to the coordinator
        persistingContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        persistingContext.persistentStoreCoordinator = coordinator
        
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = persistingContext
        
        // add a sqlite store located in the documents folder
        let filemanager = FileManager.default
        guard let docUrl = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("unable to reach the documents folder")
            return nil
        }
        self.dbUrl = docUrl.appendingPathComponent("model.sqlite")
        
        // options for migration
        let migrationOptions = [NSInferMappingModelAutomaticallyOption: true,
                                NSMigratePersistentStoresAutomaticallyOption: true]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbUrl, options: migrationOptions)
        } catch {
            fatalError("unable to add store at \(dbUrl)")
        }
    }
    
    // MARK: Utils
    
    func addStoreCoordinator(_ storeType: String, configuration: String?, storeURL: URL, options : [NSObject:AnyObject]?) throws {
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbUrl, options: nil)
    }
}

// MARK: - CoreDataStack (Removing Data)

internal extension CoreDataStack  {
    
    func dropAllData() throws {
        // delete all the objects in the db. This won't delete the files, it will
        // just leave empty tables.
        try coordinator.destroyPersistentStore(at: dbUrl, ofType: NSSQLiteStoreType , options: nil)
        try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: dbUrl, options: nil)
    }
}


// MARK:  - Save data methods

extension CoreDataStack {
    func save() {
        context.performAndWait() {
            if self.context.hasChanges {
                do {
                    try self.context.save()
                } catch {
                    fatalError("error while saving main context: \(error)")
                }
                
                // now we save in the background
                self.persistingContext.perform() {
                    do {
                        try self.persistingContext.save()
                    } catch {
                        fatalError("error whil saving persisting context: \(error)")
                    }
                }
            }
        }
    }
}







