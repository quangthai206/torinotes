//
//  AppCoordinator.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
  private let windowRouter: WindowRouterProtocol
  
  init(windowRouter: WindowRouterProtocol) {
    self.windowRouter = windowRouter
  }
  
  override func start() {
    startNoteNavCoordinator()
  }
}

// MARK: - Note Coordinator

extension AppCoordinator {
  func startNoteNavCoordinator() {
    let nc = UINavigationController()
    windowRouter.setRoot(nc, animated: false)
    
    let navRouter = NavRouter(navigationController: nc)
    let coordinator = NoteNavCoordinator(navRouter: navRouter)
    
    startChild(coordinator)
  }
}
