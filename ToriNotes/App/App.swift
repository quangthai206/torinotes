//
//  App.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit
import ToriNotesCore

class App {
  static let shared = App()
  
  // MARK: CoreData
  
  private var coreDataStack: CoreDataStack!
  
  // MARK: Note
  
  private(set) var note: NoteServiceProtocol!
  
  // MARK: Initialization
  
  private init() {}
  
  func bootstrap(
    with application: UIApplication,
    launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) {
    coreDataStack = CoreDataStack.shared
    
    note = NoteService(
      client: CoreDataNoteClient(coreDataStack: coreDataStack)
    )
  }
}
