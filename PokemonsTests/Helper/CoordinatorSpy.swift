//
//  CoordinatorSpy.swift
//  PokemonsTests
//
//  Created by Cahyanto Setya Budi on 03/06/23.
//

import UIKit
@testable import Pokemons

final class CoordinatorSpy: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController = UINavigationController()
    
    var pokemonDetailVCCalled: Bool = false
    
    var pokemonImageVCCalled: Bool = false
    
    func start() {}
    
    func showPokemonDetailVC(pokemon: Pokemons.Pokemon) {
        pokemonDetailVCCalled = true
    }
    
    func showPokemonImageVC(with url: String) {
        pokemonImageVCCalled = true
    }
}
