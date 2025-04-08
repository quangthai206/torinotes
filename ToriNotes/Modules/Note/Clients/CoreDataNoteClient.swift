//
//  CoreDataNoteClient.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation
import CoreData

final class CoreDataNoteClient: NoteClientProtocol {
  private let coreDataStack: CoreDataStack
  
  init(coreDataStack: CoreDataStack) {
    self.coreDataStack = coreDataStack
  }
}

// MARK: - Methods

extension CoreDataNoteClient {
  func createNote() -> Note {
    let note = Note.create(in: coreDataStack.context)
    try? coreDataStack.context.save()
    return note
  }
  
  func save(note: Note, content: String) {
    note.content = content
    note.updatedAt = Date()
    try? coreDataStack.context.save()
  }
  
  func delete(_ note: Note) {
    coreDataStack.context.delete(note)
    try? coreDataStack.context.save()
  }
  
  func makeFetchedResultsController(matching searchText: String? = nil) -> NSFetchedResultsController<Note> {
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
