//
//  CoreDataNoteClient.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation
import CoreData

public final class CoreDataNoteClient: NoteClientProtocol {
  private let coreDataStack: CoreDataStack
  
  public init(coreDataStack: CoreDataStack) {
    self.coreDataStack = coreDataStack
  }
}

// MARK: - Methods

extension CoreDataNoteClient {
  public func createNote() -> Note {
    let note = Note.create(in: coreDataStack.context)
    try? coreDataStack.context.save()
    return note
  }
  
  public func save(note: Note, content: String) {
    note.content = content
    note.updatedAt = Date()
    try? coreDataStack.context.save()
  }
  
  public func delete(_ note: Note) {
    coreDataStack.context.delete(note)
    try? coreDataStack.context.save()
  }
  
  public func makeFetchedResultsController(matching searchText: String? = nil) -> NSFetchedResultsController<Note> {
    let request: NSFetchRequest<Note> = Note.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.updatedAt, ascending: false)]
    
    if let text = searchText, !text.isEmpty {
      request.predicate = NSPredicate(format: "content CONTAINS[cd] %@", text, text)
    }
    
    return NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: coreDataStack.context,
      sectionNameKeyPath: nil,
      cacheName: nil
    )
  }
}
