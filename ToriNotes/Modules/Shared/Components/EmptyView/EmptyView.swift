//
//  EmptyView.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit
import ToriNotesCore

final class EmptyView: UIView, NibLoadable {
  var viewModel: EmptyViewModelProtocol! {
    didSet { refresh() }
  }
  
  @IBOutlet private(set) var contentView: UIView!
  @IBOutlet private(set) var iconImage: UIImageView!
  @IBOutlet private(set) var titleLabel: UILabel!
  @IBOutlet private(set) var descriptionLabel: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    loadNib()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    loadNib()
  }
}

// MARK: - Refresh

private extension EmptyView {
  func refresh() {
    guard let viewModel else { return }
    
    iconImage.image = UIImage(named: viewModel.emptyIconName)
    titleLabel.text = viewModel.titleString
    descriptionLabel.text = viewModel.descriptionString
  }
}
