//
//  NotesListViewModel.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation
import Combine

final class NotesListViewModel: NotesListViewModelProtocol {
  var searchText: String = "" {
    didSet {
      searchSubject.send(searchText)
    }
  }
  
  @Published private(set) var notes: [Note] = []
  private var allNotes: [Note] = []
  
  private let searchSubject = PassthroughSubject<String, Never>()
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    bindSearch()
    loadMockNotes()
  }
}

// MARK: - Bindings

private extension NotesListViewModel {
  func bindSearch() {
    searchSubject
      .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] keyword in
        guard let self else { return }
        self.filterNotes(with: keyword)
      }
      .store(in: &cancellables)
  }
}

// MARK: - Methods

extension NotesListViewModel {
  func fetchNotes() {
    notes = allNotes
  }
  
  func deleteNote(at index: Int) {
    let noteToDelete = notes[index]
    allNotes.removeAll { $0.id == noteToDelete.id }
    filterNotes(with: searchText)
  }
  
  func noteVM(at index: Int) -> NoteCellViewModelProtocol {
    NoteCellViewModel(note: notes[index])
  }
  
  private func filterNotes(with keyword: String) {
    if keyword.isEmpty {
      notes = allNotes
    } else {
      notes = allNotes.filter {
        $0.content.localizedCaseInsensitiveContains(keyword)
      }
    }
  }
  
  private func loadMockNotes() {
    allNotes = [
      Note(content: "Milk, Eggs, Bread"),
      Note(content: "Push, Pull, Legs"),
      Note(content: "Build a notes app in UIKit with MVVM"),
      Note(content: "Milk, Eggs, Bread"),
      Note(content: "Push, Pull, Legs"),
      Note(content: "Build a notes app in UIKit with MVVM"),
      Note(content: "Milk, Eggs, Bread"),
      Note(content: "Push, Pull, Legs"),
      Note(content: "Build a notes app in UIKit with MVVM"),
      Note(content: "Milk, Eggs, Bread"),
      Note(content: "Push, Pull, Legs"),
      Note(content: "Build a notes app in UIKit with MVVM")
    ]
    notes = allNotes
  }
}

// MARK: - Getters

extension NotesListViewModel {
  var notesCount: Int { notes.count }
  
  var notesPublisher: Published<[Note]>.Publisher { $notes }
}
