//
//  CoreDataManager.swift
//  DownloadSample
//
//  Created by ojas on 17/11/19.
//  Copyright © 2019 ojas. All rights reserved.
//

import Foundation
import CoreData

// Core data manager
class CoreDataManager {
    // Singleton - Shared Instance
    static let sharedManager: CoreDataManager = CoreDataManager()
    
    // Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DownloadSample")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved Error: \(error)")
            }
        })
        return container
    }()
    
    // Managed Object Context
    lazy var managedObjectContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    // Save to DataBase
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    // Clear the DB
    func clearAll(_ entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedObjectContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    // Save to CoreData - Sqlite DB
    func savePosts(_ posts: DisplayParse) {
        let post = Post(context: self.managedObjectContext)
        let hits = posts.hits
        hits.forEach { (hit) in
            post.title = hit.title
            post.createdAt = hit.created_At
            post.points = Int16(hit.points)
        }
        saveContext()
    }
    
    // Fetch Posts - From CoreData
    func fetchObjects() -> [Post] {
        var posts  = [Post]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Post.description())
        do {
            posts = try managedObjectContext.fetch(fetchRequest) as! [Post]
            return posts
        } catch let error as NSError {
            print("Unresolved Error: \(error) \(error.userInfo)")
        }
        for post in posts {
            print(post.title ?? "")
        }
        return []
    }
}
