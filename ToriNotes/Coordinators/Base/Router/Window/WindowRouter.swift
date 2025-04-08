//
//  WindowRouter.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit

class WindowRouter: WindowRouterProtocol {
  private(set) var window: UIWindow
  
  init(window: UIWindow) {
    self.window = window
  }
}

// MARK: - Methods

extension WindowRouter {
  func setRoot(
    _ viewController: UIViewController,
    animated: Bool
  ) {
    setRoot(
      viewController,
      animated: animated,
      completion: {}
    )
  }
  
  func setRoot(
    _ viewController: UIViewController,
    animated: Bool,
    completion: @escaping VoidResult
  ) {
    guard animated else {
      window.rootViewController = viewController
      return completion()
    }
    
    window.setRootViewControllerAnimated(
      viewController,
      duration: 0.25,
      options: .transitionCrossDissolve,
      completion: { _ in completion() }
    )
  }
  
  func presentInRoot(
    _ viewController: UIViewController,
    animated: Bool
  ) {
    window.rootViewController?.present(viewController, animated: animated)
  }
  
  func dismiss(animated: Bool) {
    dismiss(
      animated: animated,
      completion: {}
    )
  }
  
  func dismiss(
    animated: Bool,
    completion: @escaping VoidResult
  ) {
    window.rootViewController?.dismiss(
      animated: animated,
      completion: completion
    )
  }
}
