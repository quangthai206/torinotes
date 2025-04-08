//
//  Note.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation

struct Note: Identifiable, Equatable {
  let id: UUID
  var content: String
  var updatedAt: Date
  
  init(
    id: UUID = UUID(),
    content: String,
    modifiedAt: Date = Date()
  ) {
    self.id = id
    self.content = content
    self.updatedAt = modifiedAt
  }
}
