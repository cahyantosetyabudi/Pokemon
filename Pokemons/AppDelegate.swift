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
    var coordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {        
        let navigationController = UINavigationController()
        coordinator = MainCoordinator(navigationController: navigationController)
        coordinator?.start()
        
        window = UIWindow()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let repository = PokemonRemoteRepository()
        let viewModel = HomeViewModel(repository: repository)
        let homeVC = HomeVC(viewModel: viewModel)
        homeVC.coordinator = self
        navigationController.pushViewController(homeVC, animated: false)
    }
    
    func showPokemonDetailVC(pokemon: Pokemon) {
        navigationController.navigationBar.topItem?.backButtonTitle = pokemon.name
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.backgroundColor = UIColor(red: 22/255, green: 27/255, blue: 34/255, alpha: 1.0)
        let repository = PokemonRemoteRepository()
        let viewModel = PokemonDetailViewModel(pokemon: pokemon, repository: repository)
        let pokemonDetailVC = PokemonDetailVC(viewModel: viewModel)
        pokemonDetailVC.coordinator = self
        navigationController.pushViewController(pokemonDetailVC, animated: true)
    }
}
