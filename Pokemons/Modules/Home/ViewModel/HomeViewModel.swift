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
    var pokemons: Driver<[Pokemon]> { get }
    var isFetching: Driver<Bool> { get }
    
    func search(_ keyword: String?)
    func loadMore(page: Int, indexPath: IndexPath)
}

final class HomeViewModel: HomeViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let repository: PokemonRepository
    private let _pokemons: BehaviorRelay<[Pokemon]> = .init(value: [])
    private let _isFetching: BehaviorRelay<Bool> = .init(value: false)
    private let _keyword: BehaviorRelay<String?> = .init(value: nil)
    private let _currentPage: BehaviorRelay<Int> = .init(value: 1)
    
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
    
    func search(_ keyword: String?) {
        _pokemons.accept([])
        _keyword.accept(keyword)
        fetchPokemons(with: keyword, page: 1)
    }
    
    private func fetchPokemons(with keyword: String?, page: Int) {
        _isFetching.accept(true)
        _currentPage.accept(page)
        repository.getPokemons(keyword: keyword, page: page, pageSize: pageSize) { [weak self] response, error in
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
    
    func loadMore(page: Int, indexPath: IndexPath) {
        guard _pokemons.value.count >= 10, _pokemons.value.count - indexPath.row >= 5, page >= self._currentPage.value, !_isFetching.value else { return }
        
        fetchPokemons(with: _keyword.value, page: page + 1)
    }
}
