//
//  UINavigationController+PopCompletion.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit

extension UINavigationController {
  func pushViewController(
    _ viewController: UIViewController,
    animated: Bool,
    completion: VoidResult? = nil
  ) {
    pushViewController(viewController, animated: animated)

    guard animated else {
      completion?()
      return
    }

    if let coordinator = transitionCoordinator {
      coordinator.animate(alongsideTransition: nil) { _ in
        completion?()
      }
    } else {
      completion?()
    }
  }

  func popViewController(
    animated: Bool,
    completion: VoidResult? = nil
  ) {
    popViewController(animated: animated)

    guard animated else {
      completion?()
      return
    }

    if let coordinator = transitionCoordinator {
      coordinator.animate(alongsideTransition: nil) { _ in
        completion?()
      }
    } else {
      completion?()
    }
  }

  func popToRootViewController(
    animated: Bool,
    completion: VoidResult? = nil
  ) {
    popToRootViewController(animated: animated)

    guard animated else {
      completion?()
      return
    }

    if let coordinator = transitionCoordinator {
      coordinator.animate(alongsideTransition: nil) { _ in
        completion?()
      }
    } else {
      completion?()
    }
  }

  func popToViewController(
    _ viewController: UIViewController,
    animated: Bool,
    completion: @escaping () -> Void
  ) {
    popToViewController(
      viewController,
      animated: animated
    )

    guard animated else {
      completion()
      return
    }

    if let coordinator = transitionCoordinator {
      coordinator.animate(alongsideTransition: nil) { _ in
        completion()
      }
    } else {
      completion()
    }
  }
}
