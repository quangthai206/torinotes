//
//  NoteClientProtocol.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation
import CoreData

protocol NoteClientProtocol {
  func createNote() -> Note
  func save(note: Note, content: String)
  func delete(_ note: Note)
  func makeFetchedResultsController(matching searchText: String?) -> NSFetchedResultsController<Note>
}
