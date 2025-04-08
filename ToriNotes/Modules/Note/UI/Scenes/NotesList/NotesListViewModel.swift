//
//  NotesListViewModel.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation
import Combine
import CoreData

final class NotesListViewModel: NotesListViewModelProtocol {
  @Published var searchText: String = ""
  @Published private(set) var isSearchEmpty: Bool = false
  
  private let reloadSubject = PassthroughSubject<Void, Never>()
  private let notesCountTextSubject = CurrentValueSubject<String, Never>("0 Notes")
  private var fetchedResultsController: NSFetchedResultsController<Note>
  private let noteService: NoteServiceProtocol
  
  private var cancellables = Set<AnyCancellable>()
  
  init(noteService: NoteServiceProtocol) {
    self.noteService = noteService
    fetchedResultsController = noteService.makeFetchedResultsController(matching: nil)
    try? fetchedResultsController.performFetch()
    bindFetchedObjects()
    bindSearch()
  }
}

// MARK: - Bindings

private extension NotesListViewModel {
  func bindSearch() {
    $searchText
      .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] keyword in
        self?.updateFetchedResultsController(with: keyword)
      }
      .store(in: &cancellables)
  }
  
  private func bindFetchedObjects() {
    NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange)
      .sink { [weak self] _ in
        self?.updateNotesCount()
      }
      .store(in: &cancellables)
  }
}

// MARK: - Methods

extension NotesListViewModel {
  func deleteNote(at index: Int) {
    guard
      let fetchedObjects = fetchedResultsController.fetchedObjects,
      fetchedObjects.indices.contains(index)
    else { return }
    
    noteService.delete(fetchedObjects[index])
  }
  
  func noteVM(at index: Int) -> NoteCellViewModelProtocol? {
    guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
      return nil
    }
    
    return NoteCellViewModel(note: fetchedObjects[index])
  }
  
  func note(at index: Int) -> Note? {
    guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
      return nil
    }
    
    return fetchedObjects[index]
  }
  
  func setFetchedResultsDelegate(_ delegate: NSFetchedResultsControllerDelegate) {
    fetchedResultsController.delegate = delegate
  }
  
  private func updateFetchedResultsController(with text: String) {
    let newFRC = noteService.makeFetchedResultsController(matching: text)
    newFRC.delegate = fetchedResultsController.delegate
    try? newFRC.performFetch()
    fetchedResultsController = newFRC
    updateNotesCount()
    reloadSubject.send()
  }
  
  private func updateNotesCount() {
    let count = fetchedResultsController.fetchedObjects?.count ?? 0
    let label = "\(count) Note\(count == 1 ? "" : "s")"
    notesCountTextSubject.send(label)
    isSearchEmpty = notesCount == 0 && !searchText.isEmpty
  }
}

// MARK: - Getters

extension NotesListViewModel {
  var notesCount: Int { fetchedResultsController.fetchedObjects?.count ?? 0 }
  var reloadPublisher: AnyPublisher<Void, Never> {
    reloadSubject.eraseToAnyPublisher()
  }
  var notesCountTextPublisher: AnyPublisher<String, Never> {
    notesCountTextSubject.eraseToAnyPublisher()
  }
  var isSearchEmptyPublisher: AnyPublisher<Bool, Never> {
    $isSearchEmpty.eraseToAnyPublisher()
  }
  var emptyVM: EmptyViewModelProtocol { SearchEmptyViewModel() }
}
