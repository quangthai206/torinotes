//
//  UIViewController+Identifier.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit

protocol StoryboardIdentifiable {
  static var storyboardID: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
  static var storyboardID: String {
    String(describing: self)
  }
}

extension UIViewController: StoryboardIdentifiable {}
