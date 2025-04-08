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
    
    navRouter.setRoot(vc, animated: true)
  }
}
