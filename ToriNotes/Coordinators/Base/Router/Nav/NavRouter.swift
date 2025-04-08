//
//  NavRouter.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit

class NavRouter: NSObject, NavRouterProtocol {
  private(set) var closures: [String: VoidResult] = [:]
  
  let navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    
    super.init()
    
    navigationController.delegate = self
  }
}

// MARK: - Methods

extension NavRouter {
  func setRoot(
    _ viewController: UIViewController,
    animated: Bool
  ) {
    setViewControllers(
      [viewController],
      animated: animated
    )
  }
  
  func present(
    _ viewController: UIViewController,
    animated: Bool
  ) {
    present(
      viewController,
      animated: animated,
      completion: {}
    )
  }
  
  func present(
    _ viewController: UIViewController,
    animated: Bool,
    completion: @escaping VoidResult
  ) {
    navigationController.present(
      viewController,
      animated: true,
      completion: completion
    )
  }
  
  func setViewControllers(
    _ viewControllers: [UIViewController],
    animated: Bool
  ) {
    navigationController.setViewControllers(
      viewControllers,
      animated: animated
    )
  }
  
  func push(
    _ viewController: UIViewController,
    animated: Bool
  ) {
    push(
      viewController,
      animated: true,
      onNavigateBack: nil
    )
  }
  
  func push(
    _ viewController: UIViewController,
    animated: Bool,
    onNavigateBack: VoidResult?
  ) {
    if let closure = onNavigateBack {
      closures.updateValue(
        closure,
        forKey: viewController.description
      )
    }
    
    navigationController.pushViewController(
      viewController,
      animated: animated
    )
  }
  
  func popToRoot(animated: Bool) {
    popToRoot(
      animated: animated,
      completion: {}
    )
  }
  
  func popToRoot(
    animated: Bool,
    completion: @escaping VoidResult
  ) {
    navigationController.popToRootViewController(
      animated: animated,
      completion: completion
    )
  }
  
  func popToViewController(
    _ viewController: UIViewController,
    animated: Bool
  ) {
    popToViewController(
      viewController,
      animated: animated,
      completion: {}
    )
  }
  
  func popToViewController(
    _ viewController: UIViewController,
    animated: Bool,
    completion: @escaping VoidResult
  ) {
    navigationController.popToViewController(
      viewController,
      animated: animated,
      completion: completion
    )
  }
  
  func pop(animated: Bool) {
    pop(
      animated: animated,
      completion: {}
    )
  }
  
  func pop(
    animated: Bool,
    completion: @escaping VoidResult
  ) {
    navigationController.popViewController(
      animated: animated,
      completion: completion
    )
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
    navigationController.dismiss(
      animated: animated,
      completion: completion
    )
  }
}

// MARK: - UINavigationControllerDelegate

extension NavRouter: UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
  ) {
    guard
      let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from),
      !navigationController.viewControllers.contains(previousController)
    else { return }
    
    if let closure = closures.removeValue(forKey: previousController.description) {
      return closure()
    }
  }
}
