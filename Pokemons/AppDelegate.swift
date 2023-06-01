//
//  AppDelegate.swift
//  Pokemons
//
//  Created by Cahyanto Setya Budi on 30/05/23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let repository = PokemonRemoteRepository()
        let viewModel = HomeViewModel(repository: repository)
        let homeVC = HomeVC(viewModel: viewModel)
        window = UIWindow()
        window?.rootViewController = homeVC
        window?.makeKeyAndVisible()

        return true
    }
}

