//
//  Note+CoreDataProperties.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//
//

import Foundation
import CoreData

extension Note {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
    return NSFetchRequest<Note>(entityName: "Note")
  }
  
  @NSManaged public var id: UUID!
  @NSManaged public var content: String!
  @NSManaged public var updatedAt: Date!
}

extension Note : Identifiable {
  
}

extension Note {
  static func create(in context: NSManagedObjectContext) -> Note {
    let note = Note(context: context)
    note.id = UUID()
    note.content = ""
    note.updatedAt = Date()
    return note
  }
}
