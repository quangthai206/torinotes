//
//  Window+RootController.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit

extension UIWindow {
  func setRootViewControllerAnimated(
    _ controller: UIViewController?,
    duration: TimeInterval = 0.25,
    options: UIView.AnimationOptions = .transitionCrossDissolve,
    completion: ((_ finished: Bool) -> Void)? = nil
  ) {
    UIView.transition(with: self, duration: duration, options: options, animations: {
      let oldState = UIView.areAnimationsEnabled
      UIView.setAnimationsEnabled(false)
      self.rootViewController = controller
      UIView.setAnimationsEnabled(oldState)
    }, completion: completion)
  }
}
