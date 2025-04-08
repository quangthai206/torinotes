//
//  NotesListViewModelProtocol.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation

protocol NotesListViewModelProtocol {
  var notesCount: Int { get }
  var notesPublisher: Published<[Note]>.Publisher { get }
  var searchText: String { get set }
  
  func fetchNotes()
  func deleteNote(at index: Int)
  func noteVM(at index: Int) -> NoteCellViewModelProtocol
}
