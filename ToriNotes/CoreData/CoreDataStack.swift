//
//  CoreDataStack.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation
import CoreData

class CoreDataStack {
  static let shared = CoreDataStack()
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "ToriNotes")
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
