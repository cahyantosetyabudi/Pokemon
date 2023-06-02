//
//  MainCoordinator.swift
//  Pokemons
//
//  Created by Cahyanto Setya Budi on 02/06/23.
//

import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
    func showPokemonDetailVC(pokemon: Pokemon)
    func showPokemonImageVC(with url: String)
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
    
    func showPokemonImageVC(with url: String) {
        let viewModel = PokemonImageViewModel(imageUrlString: url)
        let pokemonImageVC = PokemonImageVC(viewModel: viewModel)
        pokemonImageVC.modalPresentationStyle = .overFullScreen
        navigationController.present(pokemonImageVC, animated: true)
    }
}
