//
//  AppDelegate.swift
//  Notes
//
//  Created by User on 13.12.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window {
            let navigationController = UINavigationController()
            let viewController = NotesListViewController()
            viewController.viewModel = NotesListViewModel()
            navigationController.viewControllers = [viewController]
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        
        return true
    }
}
