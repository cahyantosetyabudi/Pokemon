//
//  HomeViewModelSpy.swift
//  PokemonsTests
//
//  Created by Cahyanto Setya Budi on 03/06/23.
//

import Foundation
import RxCocoa
@testable import Pokemons

final class HomeViewModelSpy: HomeViewModelProtocol {
    private let _pokemons: PublishRelay<[Pokemon]> = .init()
    var pokemons: Driver<[Pokemon]> {
        _pokemons.asDriver(onErrorDriveWith: .empty())
    }
    
    private let _isFetching: PublishRelay<Bool> = .init()
    var isFetching: Driver<Bool> {
        _isFetching.asDriver(onErrorDriveWith: .empty())
    }
    
    var keyword: String?
    var loadMoreCalled: Bool = false
    
    func search(_ keyword: String?) {
        self.keyword = keyword
    }
    
    func loadMore(page: Int, indexPath: IndexPath) {
        loadMoreCalled = true
    }
    
    func setIsFetching(_ isFetching: Bool) {
        _isFetching.accept(isFetching)
    }
    
    func setPokemonList(_ pokemons: [Pokemon]) {
        _pokemons.accept(pokemons)
    }
}
