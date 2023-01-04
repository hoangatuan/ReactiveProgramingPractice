//
//  AppDelegate.swift
//  RxSwiftPractice
//
//  Created by Digilife on 12/06/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = UINavigationController(rootViewController: CombineMovieSearchViewController(
            viewModel: CombineMovieSearchViewModel(
                useCase: SearchMovieUseCase(repository: SearchMovieRepository())
            )
        ))
        window.makeKeyAndVisible()

        return true
    }

}

