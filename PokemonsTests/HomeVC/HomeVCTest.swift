//
//  HomeVCTest.swift
//  PokemonsTests
//
//  Created by Cahyanto Setya Budi on 02/06/23.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Pokemons

final class HomeVCTest: XCTestCase {

    func testViewDidLoadShouldInitView() {
        let viewModel = HomeViewModelSpy()
        let sut = HomeVC(viewModel: viewModel)
        
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.searchBar)
        XCTAssertNotNil(sut.pokemonsCollectionView)
        XCTAssertNotNil(sut.activityIndicator)
        XCTAssertNotNil(sut.pokemonsCollectionView.delegate)
    }
    
    func testViewDidLoadShouldSearchPokemonWitKeywordNil() {
        let viewModel = HomeViewModelSpy()
        let sut = HomeVC(viewModel: viewModel)
        
        sut.loadViewIfNeeded()

        XCTAssertNil(viewModel.keyword)
    }
    
    func testViewDidLoadShouldShowActivityIndicatorWhenIsFetchingTrue() {
        let viewModel = HomeViewModelSpy()
        let sut = HomeVC(viewModel: viewModel)
        
        sut.loadViewIfNeeded()
        viewModel.setIsFetching(true)

        XCTAssertFalse(sut.activityIndicator.isHidden)
        XCTAssertTrue(sut.activityIndicator.isAnimating)
    }
    
    func testViewDidLoadShouldHideActivityIndicatorWhenIsFetchingFalse() {
        let viewModel = HomeViewModelSpy()
        let sut = HomeVC(viewModel: viewModel)
        
        sut.loadViewIfNeeded()
        viewModel.setIsFetching(false)

        XCTAssertTrue(sut.activityIndicator.isHidden)
        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }
    
    func testViewDidLoadShouldShowItemsCellWhenPokemonNotEmpty() {
        let viewModel = HomeViewModelSpy()
        let sut = HomeVC(viewModel: viewModel)
        
        sut.loadViewIfNeeded()
        var pokemons: [Pokemon] = []
        for _ in 0...5 {
            let legalities = Legalities(unlimited: Expanded.legal, expanded: nil)
            let image = Set(id: "", name: "", series: "", printedTotal: 0, total: 0, legalities: legalities, ptcgoCode: nil, releaseDate: "", updatedAt: "", images: SetImages(symbol: "", logo: ""))
            let pokemon = Pokemon(id: "", name: "", supertype: "", subtypes: [], level: nil, hp: "", types: [], evolvesFrom: nil, abilities: nil, attacks: nil, weaknesses: nil, resistances: nil, retreatCost: nil, convertedRetreatCost: nil, datumSet: image, number: nil, artist: nil, rarity: nil, flavorText: nil, nationalPokedexNumbers: [], legalities: legalities, images: DatumImages(small: "", large: ""), tcgplayer: nil, cardmarket: nil, evolvesTo: nil, rules: nil)
            pokemons.append(pokemon)
        }
        viewModel.setPokemonList(pokemons)
        sut.pokemonsCollectionView.dataSource?.collectionView(sut.pokemonsCollectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(sut.pokemonsCollectionView.numberOfItems(inSection: 0), pokemons.count)
    }
    
    func testViewDidLoadShouldShowEmptyCellWhenPokemonEmpty() {
        let viewModel = HomeViewModelSpy()
        let sut = HomeVC(viewModel: viewModel)
        
        sut.loadViewIfNeeded()
        viewModel.setPokemonList([])
        
        XCTAssertEqual(sut.pokemonsCollectionView.numberOfItems(inSection: 0), 0)
    }
    
    func testViewDidLoadShouldLoadMorePokemonWhenWillDisplayCell() {
        let viewModel = HomeViewModelSpy()
        let sut = HomeVC(viewModel: viewModel)
        
        sut.loadViewIfNeeded()
        sut.pokemonsCollectionView.delegate?.collectionView?(sut.pokemonsCollectionView, willDisplay: UICollectionViewCell(), forItemAt: IndexPath())

        XCTAssertTrue(viewModel.loadMoreCalled)
    }
    
    func testViewDidLoadShouldShowPokemonDetailWhenModelSelected() {
        let viewModel = HomeViewModelSpy()
        let sut = HomeVC(viewModel: viewModel)
        let coordinator = CoordinatorSpy()
        sut.coordinator = coordinator
        
        sut.loadViewIfNeeded()
        let legalities = Legalities(unlimited: Expanded.legal, expanded: nil)
        let image = Set(id: "", name: "", series: "", printedTotal: 0, total: 0, legalities: legalities, ptcgoCode: nil, releaseDate: "", updatedAt: "", images: SetImages(symbol: "", logo: ""))
        let pokemon = Pokemon(id: "", name: "", supertype: "", subtypes: [], level: nil, hp: "", types: [], evolvesFrom: nil, abilities: nil, attacks: nil, weaknesses: nil, resistances: nil, retreatCost: nil, convertedRetreatCost: nil, datumSet: image, number: nil, artist: nil, rarity: nil, flavorText: nil, nationalPokedexNumbers: [], legalities: legalities, images: DatumImages(small: "", large: ""), tcgplayer: nil, cardmarket: nil, evolvesTo: nil, rules: nil)
        viewModel.setPokemonList([pokemon])

        sut.pokemonsCollectionView.delegate?.collectionView?(sut.pokemonsCollectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

        XCTAssertTrue(coordinator.pokemonDetailVCCalled)
    }
    
    func testViewWillAppearShouldHideNavbar() {
        let viewModel = HomeViewModelSpy()
        let sut = HomeVC(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: sut)
        var window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        sut.loadViewIfNeeded()
        sut.viewWillAppear(false)
        
        XCTAssertTrue(navigationController.navigationBar.isHidden)
    }
    
    func testViewWillDisappearShouldShowNavbar() {
        let viewModel = HomeViewModelSpy()
        let sut = HomeVC(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: sut)
        var window = UIWindow()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        sut.loadViewIfNeeded()
        sut.viewWillDisappear(false)
        
        XCTAssertFalse(navigationController.navigationBar.isHidden)
    }
}


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

final class CoordinatorSpy: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController = UINavigationController()
    
    var pokemonDetailVCCalled: Bool = false
    
    func start() {}
    
    func showPokemonDetailVC(pokemon: Pokemons.Pokemon) {
        pokemonDetailVCCalled = true
    }
}
