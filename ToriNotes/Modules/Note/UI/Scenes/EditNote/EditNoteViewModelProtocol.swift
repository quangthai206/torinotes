//
//  EditNoteViewModelProtocol.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation

protocol EditNoteViewModelProtocol {
  var contentText: String { get set }
  
  func saveIfNeeded()
}
