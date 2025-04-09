//
//  NotesListViewModelTests.swift
//  ToriNotesCoreTests
//
//  Created by Quang Thai on 9/4/25.
//

import XCTest
import CoreData
import Combine
@testable import ToriNotesCore

final class NotesListViewModelTests: XCTestCase {
  var coreDataStack: CoreDataStack!
  var noteClient: CoreDataNoteClient!
  var noteService: NoteService!
  var viewModel: NotesListViewModel!
  var cancellables = Set<AnyCancellable>()
  
  override func setUp() {
    super.setUp()
    coreDataStack = CoreDataStack.inMemory()
    noteClient = CoreDataNoteClient(coreDataStack: coreDataStack)
    noteService = NoteService(client: noteClient)
    viewModel = NotesListViewModel(noteService: noteService)
  }
  
  override func tearDown() {
    cancellables.removeAll()
    coreDataStack = nil
    noteClient = nil
    noteService = nil
    viewModel = nil
    super.tearDown()
  }
  
  func testInitialState() {
    XCTAssertEqual(viewModel.notesCount, 0, "Initial notes count should be 0")
    XCTAssertTrue(viewModel.searchText.isEmpty, "Initial search text should be empty")
  }
  
  func testAddingNote() {
    let expectation = XCTestExpectation(description: "Reload publisher should emit")
    
    let newNote = noteService.createEmptyNote()
    newNote.content = "New Note"
    try? coreDataStack.context.save()
    
    XCTAssertEqual(viewModel.notesCount, 1, "Notes count should be 1 after adding a note")
    XCTAssertEqual(viewModel.note(at: 0)?.content, "New Note", "Note content should match")
  }
  
  func testDeletingNote() {
    let note = noteService.createEmptyNote()
    try? coreDataStack.context.save()
    
    XCTAssertEqual(viewModel.notesCount, 1, "Notes count should be 1 after adding a note")
    viewModel.deleteNote(at: 0)
    try? coreDataStack.context.save()
    
    XCTAssertEqual(viewModel.notesCount, 0, "Notes count should be 0 after deleting the note")
  }
  
  func testSearchFunctionality() {
    let expectation = XCTestExpectation(description: "Reload publisher should emit")
    
    viewModel.reloadPublisher
      .sink { expectation.fulfill() }
      .store(in: &cancellables)
    
    let note1 = noteService.createEmptyNote()
    note1.content = "First Note"
    let note2 = noteService.createEmptyNote()
    note2.content = "Second Note"
    try? coreDataStack.context.save()
    
    XCTAssertEqual(viewModel.notesCount, 2, "Notes count should be 2 before searching")
    viewModel.searchText = "First"
    
    wait(for: [expectation], timeout: 1.0)
    
    XCTAssertEqual(viewModel.notesCount, 1, "Notes count should be 1 after searching")
    XCTAssertEqual(viewModel.note(at: 0)?.content, "First Note", "Search result should match the keyword")
  }
  
  func testIsSearchEmptyPublisher() {
    let expectation = XCTestExpectation(description: "isSearchEmptyPublisher should emit")
    viewModel.isSearchEmptyPublisher
      .sink { isEmpty in
        if isEmpty {
          expectation.fulfill()
        }
      }
      .store(in: &cancellables)
    
    viewModel.searchText = "Nonexistent"
    wait(for: [expectation], timeout: 1.0)
  }
}
