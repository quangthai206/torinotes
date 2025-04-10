//
//  XCUIElement+ClearText.swift
//  ToriNotesUITests
//
//  Created by Quang Thai on 10/4/25.
//

import XCTest

extension XCUIElement {
  func clearText() {
    guard let stringValue = self.value as? String else { return }
    tap()
    let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
    typeText(deleteString)
  }
}
