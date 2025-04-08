//
//  NavCoordinator.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit

class NavCoordinator: BaseCoordinator {
  let navRouter: NavRouterProtocol
  
  private(set) var baseVC: UIViewController?
  
  init(navRouter: NavRouterProtocol) {
    self.navRouter = navRouter
    baseVC = navRouter.navigationController.visibleViewController
  }
}

// MARK: - Helpers

extension NavCoordinator {
  func triggerPopToBaseVC(then callback: VoidResult? = nil) -> VoidResult {
    { [weak self] in
      guard let self else { return }
      
      guard let baseVC = self.baseVC else {
        callback?()
        return
      }
      
      self.navRouter.popToViewController(
        baseVC,
        animated: true,
        completion: callback ?? {}
      )
    }
  }
  
  func triggerPop(then callback: VoidResult? = nil) -> VoidResult {
    { [weak self] in
      guard let self else { return }
      
      self.navRouter.pop(
        animated: true,
        completion: callback ?? {}
      )
    }
  }
  
  func triggerDismiss(then callback: VoidResult? = nil) -> VoidResult {
    { [weak self] in
      guard let self else { return }
      
      self.navRouter.dismiss(
        animated: true,
        completion: callback ?? {}
      )
    }
  }
}
