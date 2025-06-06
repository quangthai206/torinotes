//
//  NotesListController.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit
import Combine
import CoreData
import ToriNotesCore

final class NotesListController: UIViewController {
  var viewModel: NotesListViewModelProtocol!
  
  var onAddNoteButtonTap: VoidResult?
  var onEditNote: SingleResult<Note>?
  
  @IBOutlet private(set) var tableView: UITableView!
  @IBOutlet private(set) var notesCountLabel: UILabel!
  @IBOutlet private(set) var emptyView: EmptyView!
  @IBOutlet private(set) var addNoteButton: UIButton!
  
  private let searchController = UISearchController(searchResultsController: nil)
  private var cancellables = Set<AnyCancellable>()
}

// MARK: - Lifecycle

extension NotesListController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    bind()
    viewModel.setFetchedResultsDelegate(self)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    navigationItem.largeTitleDisplayMode = .always
    navigationController?.navigationBar.sizeToFit()
  }
}

// MARK: - Setup

private extension NotesListController {
  func setup() {
    setupNavigation()
    setupTableView()
    setupSearchController()
    setupEmptyView()
    configureAccessibilityIdentifiers()
  }
  
  func setupNavigation() {
    title = "ToriNotes"
    navigationController?.navigationBar.prefersLargeTitles = true
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
  
  func setupEmptyView() {
    emptyView.viewModel = viewModel.emptyVM
  }
  
  func configureAccessibilityIdentifiers() {
    addNoteButton.accessibilityIdentifier = "notesListAddButton"
  }
}

// MARK: - Bindings

private extension NotesListController {
  func bind() {
    viewModel.notesCountTextPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] text in
        guard let self else { return }
        self.notesCountLabel.text = text
      }
      .store(in: &cancellables)
    
    viewModel.reloadPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        guard let self else { return }
        self.tableView.reloadData()
      }
      .store(in: &cancellables)
    
    viewModel.isSearchEmptyPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isEmpty in
        guard let self else { return }
        self.emptyView.isHidden = !isEmpty
      }
      .store(in: &cancellables)
  }
}

// MARK: - Actions

private extension NotesListController {
  @IBAction
  func addNoteButtonTapped(_ sender: Any) {
    onAddNoteButtonTap?()
  }
}

extension NotesListController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(
    _ controller: NSFetchedResultsController<NSFetchRequestResult>,
    didChange anObject: Any,
    at indexPath: IndexPath?,
    for type: NSFetchedResultsChangeType,
    newIndexPath: IndexPath?
  ) {
    switch type {
    case .insert:
      if let newIndexPath {
        tableView.insertRows(at: [newIndexPath], with: .automatic)
      }
    case .delete:
      if let indexPath {
        tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    case .update:
      if let indexPath {
        tableView.reloadRows(at: [indexPath], with: .automatic)
      }
    case .move:
      if let indexPath,
         let newIndexPath {
        tableView.moveRow(at: indexPath, to: newIndexPath)
        
        DispatchQueue.main.async { [weak self] in
          self?.tableView.reloadRows(at: [newIndexPath], with: .automatic)
        }
      }
    @unknown default:
      break
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
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
    guard let note = viewModel.note(at: indexPath.row) else {
      return
    }
    onEditNote?(note)
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
