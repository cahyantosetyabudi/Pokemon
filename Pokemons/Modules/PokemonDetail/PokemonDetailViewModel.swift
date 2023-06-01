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
    var type: Driver<String> { get }
    var subtypes: Driver<String> { get }
    var flavor: Driver<String> { get }
}

final class PokemonDetailViewModel: PokemonDetailViewModelProtocol {
    private let pokemon: BehaviorRelay<Pokemon>
    
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
    
    var type: Driver<String> {
        pokemon
            .map({ "\($0.types.first ?? "") (HP \($0.hp))" })
            .asDriver(onErrorDriveWith: .empty())
    }
    
    var subtypes: Driver<String> {
        pokemon
            .map({ "\($0.supertype) - \($0.subtypes.first ?? "")"})
            .asDriver(onErrorDriveWith: .empty())
    }
    
    var flavor: Driver<String> {
        pokemon
            .map({ $0.flavorText ?? "" })
            .map({ $0.isEmpty ? "-" : "\"\($0)\"" })
            .asDriver(onErrorDriveWith: .empty())
    }
    
    init(pokemon: Pokemon) {
        self.pokemon = .init(value: pokemon)
    }
}
