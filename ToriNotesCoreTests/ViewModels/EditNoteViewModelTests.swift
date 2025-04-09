//
//  EditNoteViewModelTests.swift
//  ToriNotesCoreTests
//
//  Created by Quang Thai on 9/4/25.
//

import XCTest
import CoreData
@testable import ToriNotesCore

final class EditNoteViewModelTests: XCTestCase {
  var coreDataStack: CoreDataStack!
  var noteClient: CoreDataNoteClient!
  var noteService: NoteService!
  var viewModel: EditNoteViewModel!
  
  override func setUp() {
    super.setUp()
    coreDataStack = CoreDataStack.inMemory()
    noteClient = CoreDataNoteClient(coreDataStack: coreDataStack)
    noteService = NoteService(client: noteClient)
  }
  
  override func tearDown() {
    coreDataStack = nil
    noteClient = nil
    noteService = nil
    viewModel = nil
    super.tearDown()
  }
  
  func testInitializeWithExistingNote() {
    let note = noteService.createEmptyNote()
    note.content = "Existing Note"
    
    viewModel = EditNoteViewModel(note: note, noteService: noteService)
    XCTAssertEqual(viewModel.contentText, "Existing Note", "ViewModel should initialize with the note's content")
  }
  
  func testInitializeWithNewNote() {
    viewModel = EditNoteViewModel(note: nil, noteService: noteService)
    XCTAssertTrue(viewModel.contentText.isEmpty, "ViewModel should initialize with an empty contentText")
  }
  
  func testSaveUpdatedContent() {
    let note = noteService.createEmptyNote()
    note.content = "Old Content"
    try? coreDataStack.context.save()
    
    viewModel = EditNoteViewModel(note: note, noteService: noteService)
    viewModel.contentText = "Updated Content"
    viewModel.saveIfNeeded()
    XCTAssertEqual(note.content, "Updated Content", "Note's content should be updated")
  }
  
  func testDeleteNoteWhenContentIsEmpty() {
    let note = noteService.createEmptyNote()
    viewModel = EditNoteViewModel(note: note, noteService: noteService)
    
    viewModel.contentText = ""
    viewModel.saveIfNeeded()
    
    let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
    let notes = try? coreDataStack.context.fetch(fetchRequest)
    XCTAssertTrue(notes?.isEmpty ?? false, "Note should be deleted when content is empty")
  }
  
  func testNoSaveWhenContentIsUnchanged() {
    let note = noteService.createEmptyNote()
    note.content = "Unchanged Content"
    try? coreDataStack.context.save()
    
    viewModel = EditNoteViewModel(note: note, noteService: noteService)
    viewModel.contentText = "Unchanged Content"
    viewModel.saveIfNeeded()
    
    let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
    let notes = try? coreDataStack.context.fetch(fetchRequest)
    XCTAssertEqual(notes?.first?.content, "Unchanged Content", "Note's content should remain unchanged")
  }
}
