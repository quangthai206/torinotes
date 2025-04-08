//
//  NotesListController.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit
import Combine

final class NotesListController: UIViewController {
  var viewModel: NotesListViewModelProtocol!
  
  @IBOutlet private(set) var tableView: UITableView!
  @IBOutlet private(set) var notesCountLabel: UILabel!
  
  private let searchController = UISearchController(searchResultsController: nil)
  private var cancellables = Set<AnyCancellable>()
}

// MARK: - Lifecycle

extension NotesListController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    navigationController?.navigationBar.sizeToFit()
  }
}

// MARK: - Setup

private extension NotesListController {
  func setup() {
    setupNavigation()
    setupTableView()
    setupSearchController()
  }
  
  func setupNavigation() {
    title = "ToriNotes"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationItem.largeTitleDisplayMode = .always
  }
  
  func setupTableView() {
    tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 36, right: 0)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(
      UINib(nibName: NoteCell.reuseIdentifier, bundle: nil),
      forCellReuseIdentifier: NoteCell.reuseIdentifier
    )
  }
  
  func setupSearchController() {
    searchController.searchBar.tintColor = .orange
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
    searchController.delegate = self
    navigationItem.searchController = searchController
  }
}

// MARK: - Bindings

private extension NotesListController {
  func bind() {
    viewModel.notesPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] notes in
        self?.tableView.reloadData()
        self?.notesCountLabel.text = "\(notes.count) Notes"
      }
      .store(in: &cancellables)
  }
}

// MARK: - Actions

private extension NotesListController {
  @IBAction
  func addNoteButtonTapped(_ sender: Any) {
    // TODO: Navigate to add note scene
  }
}

// MARK: - UITableViewDataSource & Delegate

extension NotesListController: UITableViewDataSource, UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    viewModel.notesCount
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.reuseIdentifier, for: indexPath) as? NoteCell
    else {
      return UITableViewCell()
    }
    
    let vm = viewModel.noteVM(at: indexPath.row)
    cell.viewModel = vm
    return cell
  }
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    // TODO: Navigate to edit note scene
  }
  
  func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    if editingStyle == .delete {
      viewModel.deleteNote(at: indexPath.row)
    }
  }
}

// MARK: - UISearchBarDelegate

extension NotesListController: UISearchBarDelegate {
  func searchBar(
    _ searchBar: UISearchBar,
    textDidChange searchText: String
  ) {
    viewModel.searchText = searchText
  }
}

// MARK: - UISearchControllerDelegate

extension NotesListController: UISearchControllerDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    viewModel.searchText = ""
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    viewModel.searchText = searchBar.text ?? ""
  }
}
