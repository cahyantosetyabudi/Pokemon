//
//  HomeViewModel.swift
//  Pokemons
//
//  Created by Cahyanto Setya Budi on 30/05/23.
//

import Foundation
import RxCocoa
import RxSwift
import RxRelay

protocol HomeViewModelProtocol {
    var currentPage: Int { get }
    var pokemons: Driver<[Pokemon]> { get }
    var isFetching: Driver<Bool> { get }
    
    func fetchPokemons()
    func fetchPokemonsMore(currentPage: Int, indexPath: IndexPath)
}

final class HomeViewModel: HomeViewModelProtocol {
    private let repository: PokemonRepository
    private let _pokemons: BehaviorRelay<[Pokemon]> = .init(value: [])
    private let _isFetching: BehaviorRelay<Bool> = .init(value: false)
    
    var currentPage: Int = 0
    
    private var pageSize: Int = 10

    var pokemons: Driver<[Pokemon]> {
        _pokemons.asDriver(onErrorDriveWith: .empty())
    }
    
    var isFetching: Driver<Bool> {
        _isFetching.asDriver(onErrorDriveWith: .empty())
    }
    
    init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    func fetchPokemons() {
        currentPage += 1
        _isFetching.accept(true)
        repository.getPokemons(page: currentPage, pageSize: pageSize) { [weak self] response, error in
            self?._isFetching.accept(false)
            guard error == nil else {
                return
            }
            
            guard let response = response, let pokemons = response.data else {
                return
            }
            
            var newPokemons = self?._pokemons.value
            newPokemons?.append(contentsOf: pokemons)
            self?._pokemons.accept(newPokemons ?? [])
        }
    }
    
    func fetchPokemonsMore(currentPage: Int, indexPath: IndexPath) {
        guard _pokemons.value.count >= 10,
               _pokemons.value.count - indexPath.row >= 5,
               currentPage >= self.currentPage,
              !_isFetching.value
        else { return }
        
        fetchPokemons()
    }
}
