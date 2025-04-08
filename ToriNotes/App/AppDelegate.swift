//
//  AppDelegate.swift
//  ToriNotes
//
//  Created by Quang Thai on 8/4/25.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var appCoordinator: AppCoordinator!
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    
    let windowRouter = WindowRouter(window: window)
    appCoordinator = AppCoordinator(windowRouter: windowRouter)
    appCoordinator.start()
    
    window.makeKeyAndVisible()
    
    return true
  }
}
