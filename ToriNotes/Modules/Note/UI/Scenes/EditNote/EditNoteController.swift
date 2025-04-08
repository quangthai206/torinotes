//
//  EditNoteController.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit
import Combine

final class EditNoteController: UIViewController {
  var viewModel: EditNoteViewModelProtocol!
  
  @IBOutlet private(set) var textView: UITextView!
  
  private lazy var doneButton: UIBarButtonItem = {
    UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
  }()
  
  private var cancellables = Set<AnyCancellable>()
}

// MARK: - Lifecycle

extension EditNoteController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    bind()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    textView.becomeFirstResponder()
  }
}

// MARK: - Setup

private extension EditNoteController {
  func setup() {
    
  }
}

// MARK: - Bindings

private extension EditNoteController {
  func bind() {
    NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.navigationItem.rightBarButtonItem = self?.doneButton
      }
      .store(in: &cancellables)
    
    NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.navigationItem.rightBarButtonItem = nil
      }
      .store(in: &cancellables)
  }
}

// MARK: - Actions

private extension EditNoteController {
  @objc
  private func doneButtonTapped() {
    view.endEditing(true)
  }
}
