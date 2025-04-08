//
//  EditNoteViewModel.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation

final class EditNoteViewModel: EditNoteViewModelProtocol {
  @Published var contentText: String = ""
  private var note: Note
  
  private let noteService: NoteServiceProtocol
  
  init(
    note: Note?,
    noteService: NoteServiceProtocol
  ) {
    if let note {
      self.note = note
      self.contentText = note.content
    } else {
      self.note = noteService.createEmptyNote()
    }
    
    self.noteService = noteService
  }
}

// MARK: - Methods

extension EditNoteViewModel {
  func saveIfNeeded() {
    let trimmedContent = contentText.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if trimmedContent.isEmpty {
      noteService.delete(note)
    } else if contentText != note.content {
      noteService.save(
        note: note,
        content: trimmedContent
      )
    }
  }
}
