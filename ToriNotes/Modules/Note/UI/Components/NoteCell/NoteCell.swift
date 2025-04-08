//
//  NoteCell.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit

final class NoteCell: UITableViewCell {
  static let reuseIdentifier = "NoteCell"
  
  var viewModel: NoteCellViewModelProtocol! {
    didSet {
      refresh()
    }
  }
  
  @IBOutlet private(set) var titleLabel: UILabel!
  @IBOutlet private(set) var descriptionLabel: UILabel!
  
  override func awakeFromNib() {
    setup()
  }
}

// MARK: - Setup

private extension NoteCell {
  func setup() {
    selectionStyle = .none
  }
}

// MARK: - Refresh

private extension NoteCell {
  func refresh() {
    guard viewModel != nil else { return }
    
    titleLabel.text = viewModel.titleText
    descriptionLabel.text = viewModel.descriptionText
  }
}
