//
//  DatabaseHandler.swift
//  AggieFeed
//
//  Created by Tom Abraham on 3/19/21.
//

import Foundation
import CoreData
import UIKit

class DatabaseHandler {
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    func add<T: NSManagedObject>(  type: T.Type) -> T? {
        guard let entityName = T.entity().name else { return nil }
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: viewContext) else { return nil }
        let object = T(entity: entity, insertInto: viewContext)
        return object
    }
    
    
    func fetch<T: NSManagedObject>(  type: T.Type) -> [T] {
        let request = T.fetchRequest()
        do {
            let result = try viewContext.fetch(request)
            return result as! [T]
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAll() -> Bool {
        //let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: News.fetchRequest())
        
        do {
            try viewContext.execute(delete)
            //self.save()
            return true
        } catch {
            return false
        }
    }
}
