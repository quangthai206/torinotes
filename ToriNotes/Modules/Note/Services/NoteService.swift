//
//  NoteService.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation
import Combine
import CoreData

final class NoteService: NoteServiceProtocol {
  private let client: NoteClientProtocol
  
  init(client: NoteClientProtocol) {
    self.client = client
  }
}

// MARK: - Methods

extension NoteService {
  func createEmptyNote() -> Note {
    client.createNote()
  }
  
  func save(note: Note, content: String) {
    client.save(note: note, content: content)
  }
  
  func delete(_ note: Note) {
    client.delete(note)
  }
  
  func makeFetchedResultsController(matching searchText: String? = nil) -> NSFetchedResultsController<Note> {
    client.makeFetchedResultsController(matching: searchText)
  }
}
