//
//  CoreDataStack.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation
import CoreData

class PersistentContainer: NSPersistentContainer {}

public final class CoreDataStack {
  public static let shared = CoreDataStack()
  
  private init() {}
  
  lazy var persistentContainer: PersistentContainer = {
    let container = PersistentContainer(name: "ToriNotes")
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
