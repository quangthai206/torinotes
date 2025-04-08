//
//  CoreDataStack.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation
import CoreData

class PersistentContainer: NSPersistentCloudKitContainer {}

public final class CoreDataStack {
  public static let shared = CoreDataStack()
  
  private init() {}
  
  lazy var persistentContainer: PersistentContainer = {
    let container = PersistentContainer(name: "ToriNotes")
    
    guard let description = container.persistentStoreDescriptions.first else {
      fatalError("Missing persistent store description")
    }
    
    // Enable CloudKit sync
    description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
      containerIdentifier: "iCloud.com.poc.ToriNotes"
    )
    
    // Enable history and remote sync notifications
    description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
    description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
    
    container.loadPersistentStores { (_, error) in
      if let error {
        fatalError(error.localizedDescription)
      }
    }
    
    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    
    return container
  }()
  
  var context: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  
  func saveContext() {
    if context.hasChanges {
      try? context.save()
    }
  }
}
