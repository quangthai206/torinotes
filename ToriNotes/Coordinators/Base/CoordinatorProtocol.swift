//
//  CoordinatorProtocol.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation

protocol CoordinatorProtocol: AnyObject {
  var children: [CoordinatorProtocol] { get set }
  
  func start()
}
