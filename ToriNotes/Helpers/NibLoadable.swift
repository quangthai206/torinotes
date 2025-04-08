//
//  NibLoadable.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit

protocol NibLoadable where Self: UIView {
  var contentView: UIView! { get }
}

extension NibLoadable {
  func loadNib(named nibName: String? = nil) {
    let nib = nibName ?? String(describing: type(of: self))
    Bundle.main.loadNibNamed(nib, owner: self, options: nil)
    
    // Ensure contentView exists
    guard let contentView else {
      fatalError("contentView is not connected in the XIB.")
    }
    
    contentView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(contentView)
    
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: self.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
}
