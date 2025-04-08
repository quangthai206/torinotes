//
//  UITextView+Combine.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Combine
import UIKit

extension UITextView {
  var textPublisher: AnyPublisher<String, Never> {
    NotificationCenter.default
      .publisher(for: UITextView.textDidChangeNotification, object: self)
      .compactMap { ($0.object as? UITextView)?.text }
      .eraseToAnyPublisher()
  }
}
