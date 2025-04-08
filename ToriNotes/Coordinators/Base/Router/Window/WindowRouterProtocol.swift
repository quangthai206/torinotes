//
//  WindowRouterProtocol.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit

protocol WindowRouterProtocol: AnyObject {
  var window: UIWindow { get }
  
  func setRoot(
    _ viewController: UIViewController,
    animated: Bool
  )
  
  func setRoot(
    _ viewController: UIViewController,
    animated: Bool,
    completion: @escaping VoidResult
  )
  
  func presentInRoot(
    _ viewController: UIViewController,
    animated: Bool
  )
  
  func dismiss(animated: Bool)
  
  func dismiss(
    animated: Bool,
    completion: @escaping VoidResult
  )
}
