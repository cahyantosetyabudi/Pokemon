//
//  PokemonDetailViewModelSpy.swift
//  PokemonsTests
//
//  Created by Cahyanto Setya Budi on 03/06/23.
//

import Foundation
import RxCocoa
@testable import Pokemons

final class PokemonDetailViewModelSpy: PokemonDetailViewModelProtocol {
    var thumbnailUrl: Driver<URL> {
        Driver.empty()
    }
    
    private let _name: BehaviorRelay<String> = .init(value: "")
    var name: Driver<String>{
        _name.asDriver()
    }
    
    private let _hp: BehaviorRelay<String> = .init(value: "")
    var hp: Driver<String>{
        _hp.asDriver()
    }

    private let _type: BehaviorRelay<String> = .init(value: "")
    var type: Driver<String>{
        _type.asDriver()
    }
    
    private let _supertype: BehaviorRelay<String> = .init(value: "")
    var supertype: Driver<String>{
        _supertype.asDriver()
    }
    
    private let _subtypes: BehaviorRelay<String> = .init(value: "")
    var subtypes: Driver<String>{
        _subtypes.asDriver()
    }
    
    private let _flavor: BehaviorRelay<String> = .init(value: "")
    var flavor: Driver<String>{
        _flavor.asDriver()
    }
    
    private let _onTapThumbnail: BehaviorRelay<String> = .init(value: "")
    var onTapThumbnail: Driver<String>{
        _onTapThumbnail.asDriver()
    }
    
    private let _recommendedPokemons: BehaviorRelay<[Pokemon]> = .init(value: [])
    var recommendedPokemons: Driver<[Pokemon]>{
        _recommendedPokemons.asDriver()
    }
    
    var fetchRecommendedPokemonsCalled: Bool = false
    func fetchRecommendedPokemons(types: String, subtypes: String) {
        fetchRecommendedPokemonsCalled = true
    }
    
    func didTapThumbnailImg() {
        _onTapThumbnail.accept("http://google.com")
    }
    
    func setRecommendedPokemon(_ pokemons: [Pokemon]) {
        _recommendedPokemons.accept(pokemons)
    }
    
    func setName(_ name: String) {
        _name.accept(name)
    }
    
    func setType(_ type: String, hp: String) {
        _type.accept(type)
        _hp.accept(hp)
    }
    
    func setSubtype(subtype: String, supertype: String) {
        _subtypes.accept(subtype)
        _supertype.accept(supertype)
    }
    
    func setFlavor(_ flavor: String) {
        _flavor.accept(flavor)
    }
}
