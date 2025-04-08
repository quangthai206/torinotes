//
//  NoteNavCoordinator.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit
import ToriNotesCore

final class NoteNavCoordinator: NavCoordinator {
  private(set) var noteService: NoteServiceProtocol
  
  init(
    navRouter: NavRouterProtocol,
    noteService: NoteServiceProtocol = App.shared.note
  ) {
    self.noteService = noteService
    
    super.init(navRouter: navRouter)
  }
  
  override func start() {
    setRootToNotesListScene()
  }
}

// MARK: - NotesList Scene

extension NoteNavCoordinator {
  func setRootToNotesListScene() {
    let vm = NotesListViewModel(noteService: noteService)
    
    let storyboard = UIStoryboard(name: "NotesList", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: NotesListController.storyboardID) as! NotesListController
    vc.viewModel = vm
    
    vc.onAddNoteButtonTap = trigger(
      type(of: self).pushEditNoteScene,
      passingValue: nil
    )
    vc.onEditNote = trigger(type(of: self).pushEditNoteScene)
    
    navRouter.setRoot(vc, animated: true)
  }
}

// MARK: - EditNote Scene

extension NoteNavCoordinator {
  func pushEditNoteScene(note: Note?) {
    let vm = EditNoteViewModel(
      note: note,
      noteService: noteService
    )
    
    let storyboard = UIStoryboard(name: "EditNote", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: EditNoteController.storyboardID) as! EditNoteController
    vc.viewModel = vm
    
    navRouter.push(vc, animated: true)
  }
}
