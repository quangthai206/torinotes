//
//  ToriNotesUITests.swift
//  ToriNotesUITests
//
//  Created by Quang Thai on 9/4/25.
//

import XCTest

final class ToriNotesUITests: XCTestCase {
  var app: XCUIApplication!
  
  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments = ["--uitesting"]
    app.launch()
  }
  
  override func tearDownWithError() throws {
    app = nil
  }
  
  func testAddEditDeleteNoteFlow() {
    // Add a new note
    addNote(withText: "Hello, world!")
    
    // Verify the note appears in the list
    let cell = app.tables.cells.element(boundBy: 0)
    XCTAssertTrue(cell.waitForExistence(timeout: 2))
    XCTAssertTrue(cell.staticTexts["Hello, world!"].exists)
    
    // Tap the note to edit it
    cell.tap()
    let updatedText = "Updated note content!"
    let noteTextView = app.textViews["editNoteTextView"]
    noteTextView.tap()
    noteTextView.clearText()
    noteTextView.typeText(updatedText)
    
    // Go back to the list
    app.navigationBars.buttons.element(boundBy: 0).tap()
    
    // Ensure updated text is visible
    XCTAssertTrue(app.staticTexts[updatedText].waitForExistence(timeout: 1))
    
    // Delete the updated note
    let updatedCell = app.tables.cells.element(boundBy: 0)
    updatedCell.swipeLeft()
    updatedCell.buttons["Delete"].tap()
    
    // Confirm the note is gone
    XCTAssertFalse(app.tables.cells.staticTexts[updatedText].waitForExistence(timeout: 1))
  }
  
  func testSearchFiltersNotes() {
    // Add notes
    addNote(withText: "Shopping list")
    addNote(withText: "Workout plan")
    
    // Reveal search bar
    app.swipeDown()
    
    // Type in the search field
    let searchField = app.searchFields.firstMatch
    searchField.tap()
    searchField.typeText("Workout")
    
    // Check filtering works as expected
    XCTAssertTrue(app.tables.staticTexts["Workout plan"].waitForExistence(timeout: 1))
    XCTAssertFalse(app.tables.staticTexts["Shopping list"].waitForExistence(timeout: 1))
  }
  
  func testCancelSearchRestoresAllNotes() {
    // Add notes
    addNote(withText: "Apple")
    addNote(withText: "Banana")
    
    // Reveal search bar
    app.swipeDown()
    
    // Search for a specific note
    let searchField = app.searchFields.firstMatch
    searchField.tap()
    searchField.typeText("Banana")
    
    // Verify filtering works
    XCTAssertTrue(app.tables.staticTexts["Banana"].waitForExistence(timeout: 1))
    XCTAssertFalse(app.tables.staticTexts["Apple"].waitForExistence(timeout: 1))
    
    // Cancel search
    app.buttons["Cancel"].tap()
    
    // Confirm all notes are visible again
    XCTAssertTrue(app.tables.staticTexts["Apple"].waitForExistence(timeout: 2))
  }
  
  // MARK: - Helpers
  
  private func addNote(withText text: String) {
    app.buttons["notesListAddButton"].tap()
    
    let textView = app.textViews["editNoteTextView"]
    XCTAssertTrue(textView.waitForExistence(timeout: 2))
    textView.tap()
    textView.typeText(text)
    
    // Navigate back to save the note
    app.navigationBars.buttons.element(boundBy: 0).tap()
  }
}
