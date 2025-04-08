//
//  BaseCoordinator.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import Foundation
import Combine

class BaseCoordinator: CoordinatorProtocol, TriggerableProtocol {
  var cancellable: Set<AnyCancellable> = []
  var children: [CoordinatorProtocol] = []
  
  func start() {
    fatalError("Children should implement `start`.")
  }
  
  func startChild(_ child: CoordinatorProtocol) {
    children.append(child)
    child.start()
  }
  
  func removeChild(_ child: CoordinatorProtocol) {
    if !child.children.isEmpty {
      debugPrint("WARNING: Tried removing \(String(describing: child)) with non-empty children: \(child.children)")
    }
    
    children = children.filter { $0 !== child }
  }
  
  func triggerRemoveChild(
    _ child: CoordinatorProtocol,
    then callback: VoidResult? = nil
  ) -> VoidResult {
    { [weak self, weak child] in
      guard
        let self,
        let child
      else { return }
      
      self.removeChild(child)
      callback?()
    }
  }
}
