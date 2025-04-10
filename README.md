
# ToriNotes

**ToriNotes** is a simple yet powerful notes application inspired by Apple’s Notes app. Built with **UIKit**, **MVVM-C**, **Combine**, and **Core Data**—with seamless iCloud sync via **CloudKit**—it offers a native, secure, and responsive experience with **zero third-party dependencies**. ToriNotes allows users to effortlessly create, update, delete, and search notes, with data stored locally and synced automatically across all iCloud-enabled devices.


---

## ✨ Features

- ✅ Load all saved notes
- ✅ Create, update, and delete notes
- ✅ Search notes by content
- ✅ Store notes using Core Data
- ✅ MVVM-C architecture with Combine for reactivity
- ✅ Unit tested core logic
- ✅ Bonus: iCloud sync for offline and online access
- ✅ Bonus: Encapsulated business logic in a reusable framework
- ✅ Bonus: UI testing with simulated user interactions
- ✅ Bonus: Subtle animations for improved UX

---

## 🧱 Architecture

- **UIKit + Storyboards** for the user interface
- **MVVM-C (Model-View-ViewModel-Coordinator)** for separation of concerns
- **Combine** for reactive data flow between components
- **Core Data + NSPersistentCloudKitContainer** for local + iCloud storage
- **Custom protocol-oriented service layer** for testability

---

## 🧪 Testing

- ✅ **Unit Tests** cover view models and services
- ✅ **Integration tests** with in-memory Core Data stack
- ✅ **UI Tests** for common user flows: adding, editing, searching, and deleting notes

---

## 📲 UI Testing

Tested with:

- ✅ Adding a new note
- ✅ Editing existing notes
- ✅ Deleting notes via swipe gestures
- ✅ Searching notes and canceling search

Launch arguments `--uitesting` are used to reset the state for clean test runs.

---

## 📁 Folder Structure

```
ToriNotes/
├── ToriNotes/                # Main app target
├── ToriNotesCore/            # Business logic and persistence
├── ToriNotesCoreTests/       # Unit tests
└── ToriNotesUITests/         # UI tests
```

---

## 📸 Showcase

[ToriNotes Demo](https://drive.google.com/file/d/1hf5ysOyZgrY8bcZF91j8nORD49RqQnV_/view?usp=sharing)

> _The above demo shows creating, editing, searching, and deleting a note._

---

## 🧠 Technical Challenges

### Handling UITableView Updates with NSFetchedResultsController

#### Bug Summary:

When updating a note, the `NSFetchedResultsController` triggers the `.move` change type instead of `.update`, causing the updated note to:

- Move to a new position in the list (due to sort order changes), but
- **Not refresh visually** in the `UITableView`, leading to outdated UI.

#### Why It Happens:

- In `NSFetchedResultsController` we use a sort descriptor `updateddAt` that changes when a note is edited.
- This triggers `.move`, not `.update`, because the note now belongs at a different position in the sorted results.
- `tableView.moveRow(at:to:)` moves the row **but does not reload** its contents.

#### ✅ Solution:

In the `NSFetchedResultsControllerDelegate`, handle `.move` like this:

```swift
case .move:
  if let indexPath,
     let newIndexPath {
    tableView.moveRow(at: indexPath, to: newIndexPath)

    // Reload the moved row to reflect updated content
    DispatchQueue.main.async { [weak self] in
      self?.tableView.reloadRows(at: [newIndexPath], with: .automatic)
    }
  }
```

#### 🙌 What I Learned

- `NSFetchedResultsController` quirks and `.move` vs `.update` behavior

---

## 🚀 Getting Started

1. Clone the repo:
   ```bash
   git clone https://github.com/quangthai206/torinotes.git
   cd torinotes
   ```

2. Open `ToriNotes.xcodeproj` in Xcode

3. Run the app on simulator or device

4. Run tests with ⌘U

---

## 🛠 Requirements

- iOS 16.0+
- Xcode 15+
- Swift 5+

---

## 📄 License

MIT License

---

## 📬 Contact

If you have any questions or feedback, feel free to reach out via GitHub Issues.
