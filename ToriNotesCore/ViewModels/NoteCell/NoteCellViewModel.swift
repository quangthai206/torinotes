//
//  NoteCellViewModel.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation

final class NoteCellViewModel: NoteCellViewModelProtocol {
  private let note: Note
  
  init(note: Note) {
    self.note = note
  }
}

// MARK: - Getters

extension NoteCellViewModel {
  var titleText: String { lines.first ?? "" }
  var descriptionText: String {
    var lines = lines
    lines.removeFirst()
    return "\(note.updatedAt.format()) \(lines.first ?? "")"
  }
  
  private var lines: [String] {
    note.content
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .components(separatedBy: .newlines)
  }
}
