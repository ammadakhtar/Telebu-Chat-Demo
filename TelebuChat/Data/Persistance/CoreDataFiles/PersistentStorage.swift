//
//  PersistentStorage.swift
//  TelebuChat
//
//  Created by Ammad on 12/08/2021.
//

import Foundation
import CoreData

final class PersistentStorage {
    
    static let shared = PersistentStorage()
    
    // so no other instance can be created of this class
    private init(){}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "TelebuChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type, offSet: Int) -> [T]? {
        do {
            let request = managedObject.fetchRequest()
            request.fetchLimit = kLimit
            request.fetchOffset = offSet
            // Just added as a proof of knowledge
           // let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: true)
          // request.sortDescriptors = [sortDescriptor]
            guard let result = try PersistentStorage.shared.context.fetch(request) as? [T] else {return nil}
            return result
        } catch let error {
            debugPrint(error)
        }
        return nil
    }
}
