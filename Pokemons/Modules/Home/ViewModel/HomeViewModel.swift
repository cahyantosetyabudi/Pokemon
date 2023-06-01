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
    
    private var _currentPage: Int = 0
    
    private var pageSize: Int = 10

    var pokemons: Driver<[Pokemon]> {
        _pokemons.asDriver(onErrorDriveWith: .empty())
    }
    
    var isFetching: Driver<Bool> {
        _isFetching.asDriver(onErrorDriveWith: .empty())
    }
    
    init(repository: PokemonRepository) {
        self.repository = repository
        
        _keyword
            .subscribe(onNext: { [weak self] keyword in
                self?.fetchPokemons(with: keyword)
            })
            .disposed(by: disposeBag)
    }
    
    func search(_ keyword: String?) {
        _currentPage = 0
        _pokemons.accept([])
        _keyword.accept(keyword)
    }
    
    private func fetchPokemons(with keyword: String?) {
        _currentPage += 1
        _isFetching.accept(true)
        repository.getPokemons(keyword: keyword, types: nil, subtypes: nil, page: _currentPage, pageSize: pageSize) { [weak self] response, error in
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
        guard _pokemons.value.count >= 10,
               _pokemons.value.count - indexPath.row >= 5,
               page >= self._currentPage,
              !_isFetching.value
        else { return }
        
        _keyword.accept(_keyword.value)
    }
}
