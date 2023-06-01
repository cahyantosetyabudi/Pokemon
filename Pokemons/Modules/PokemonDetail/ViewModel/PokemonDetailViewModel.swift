//
//  PokemonDetailViewModel.swift
//  Pokemons
//
//  Created by Cahyanto Setya Budi on 01/06/23.
//

import Foundation
import RxSwift
import RxCocoa

protocol PokemonDetailViewModelProtocol {
    var thumbnailUrl: Driver<URL> { get }
    var name: Driver<String> { get }
    var hp: Driver<String> { get }
    var type: Driver<String> { get }
    var supertype: Driver<String> { get }
    var subtypes: Driver<String> { get }
    var flavor: Driver<String> { get }
    var onTapThumbnail: Driver<String> { get }
    var recommendedPokemons: Driver<[Pokemon]> { get }
    
    func fetchRecommendedPokemons(types: String, subtypes: String)
    func didTapThumbnailImg()
}

final class PokemonDetailViewModel: PokemonDetailViewModelProtocol {
    private let repository: PokemonRepository
    private let pokemon: BehaviorRelay<Pokemon>
    private let _recommendedPokemons: BehaviorRelay<[Pokemon]> = .init(value: [])
    private let _onTapThumbnail: PublishSubject<Void> = .init()
    
    var thumbnailUrl: Driver<URL> {
        pokemon
            .compactMap({ URL(string: $0.images.large) })
            .asDriver(onErrorDriveWith: .empty())
    }
    
    var name: Driver<String> {
        pokemon
            .map({ $0.name })
            .asDriver(onErrorDriveWith: .empty())
    }
    
    var hp: Driver<String> {
        pokemon
            .map({ $0.hp })
            .asDriver(onErrorDriveWith: .empty())
    }
    
    var type: Driver<String> {
        pokemon
            .map({ $0.types.first ?? "" })
            .asDriver(onErrorDriveWith: .empty())
    }
    
    var supertype: Driver<String> {
        pokemon
            .map({ $0.supertype })
            .asDriver(onErrorDriveWith: .empty())
    }
    
    var subtypes: Driver<String> {
        pokemon
            .map({ $0.subtypes.first ?? "" })
            .asDriver(onErrorDriveWith: .empty())
    }
    
    var flavor: Driver<String> {
        pokemon
            .map({ $0.flavorText ?? "" })
            .map({ $0.isEmpty ? "-" : "\"\($0)\"" })
            .asDriver(onErrorDriveWith: .empty())
    }
    
    var onTapThumbnail: Driver<String> {
        _onTapThumbnail
            .withLatestFrom(pokemon)
            .map({ $0.images.large })
            .asDriver(onErrorDriveWith: .empty())
    }
    
    var recommendedPokemons: Driver<[Pokemon]> {
        _recommendedPokemons.asDriver()
    }
    
    init(pokemon: Pokemon, repository: PokemonRepository) {
        self.repository = repository
        self.pokemon = .init(value: pokemon)
    }
    
    func didTapThumbnailImg() {
        _onTapThumbnail.onNext(())
    }
    
    func fetchRecommendedPokemons(types: String, subtypes: String) {
        repository.getRecommendedPokemons(types: types, subtypes: subtypes, page: 1, pageSize: 10) { [weak self] response, error in
            guard error == nil else {
                return
            }
            
            guard let response = response, let pokemons = response.data else {
                return
            }

            var newPokemons = self?._recommendedPokemons.value
            newPokemons?.append(contentsOf: pokemons)
            self?._recommendedPokemons.accept(newPokemons ?? [])
        }
    }
}
