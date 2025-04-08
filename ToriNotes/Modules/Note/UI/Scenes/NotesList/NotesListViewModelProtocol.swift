//
//  NotesListViewModelProtocol.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation
import CoreData
import Combine

protocol NotesListViewModelProtocol {
  var notesCount: Int { get }
  var reloadPublisher: AnyPublisher<Void, Never> { get }
  var notesCountTextPublisher: AnyPublisher<String, Never> { get }
  var isSearchEmptyPublisher: AnyPublisher<Bool, Never> { get }
  var searchText: String { get set }
  var emptyVM: EmptyViewModelProtocol { get }
  
  func deleteNote(at index: Int)
  func noteVM(at index: Int) -> NoteCellViewModelProtocol?
  func note(at index: Int) -> Note?
  
  func setFetchedResultsDelegate(_ delegate: NSFetchedResultsControllerDelegate)
}
