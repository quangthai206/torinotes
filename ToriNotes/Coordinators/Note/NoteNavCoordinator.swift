//
//  NoteNavCoordinator.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit

final class NoteNavCoordinator: NavCoordinator {
  override func start() {
    setRootToNotesListScene()
  }
}

// MARK: - NotesList Scene

extension NoteNavCoordinator {
  func setRootToNotesListScene() {
    let vm = NotesListViewModel()
    
    let storyboard = UIStoryboard(name: "NotesList", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: NotesListController.storyboardID) as! NotesListController
    vc.viewModel = vm
    
    vc.onAddNoteButtonTap = trigger(type(of: self).pushEditNoteScene)
    
    navRouter.setRoot(vc, animated: true)
  }
}

// MARK: - EditNote Scene

extension NoteNavCoordinator {
  func pushEditNoteScene() {
    let vm = EditNoteViewModel()
    
    let storyboard = UIStoryboard(name: "EditNote", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: EditNoteController.storyboardID) as! EditNoteController
    vc.viewModel = vm
    
    navRouter.push(vc, animated: true)
  }
}
