//
//  NoteService.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation
import Combine
import CoreData

public final class NoteService: NoteServiceProtocol {
  private let client: NoteClientProtocol
  
  public init(client: NoteClientProtocol) {
    self.client = client
  }
}

// MARK: - Methods

extension NoteService {
  public func createEmptyNote() -> Note {
    client.createNote()
  }
  
  public func save(note: Note, content: String) {
    client.save(note: note, content: content)
  }
  
  public func delete(_ note: Note) {
    client.delete(note)
  }
  
  public func makeFetchedResultsController(matching searchText: String? = nil) -> NSFetchedResultsController<Note> {
    client.makeFetchedResultsController(matching: searchText)
  }
}
