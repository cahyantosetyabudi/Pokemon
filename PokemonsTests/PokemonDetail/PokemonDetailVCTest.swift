//
//  PokemonDetailVCTest.swift
//  PokemonsTests
//
//  Created by Cahyanto Setya Budi on 02/06/23.
//

import XCTest
import RxCocoa
@testable import Pokemons

final class PokemonDetailVCTest: XCTestCase {
    
    func testViewDidLoadShouldSetupView() {
        let viewModel = PokemonDetailViewModelSpy()
        let sut = PokemonDetailVC(viewModel: viewModel)
        
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.thumbnailImg.gestureRecognizers)
        XCTAssertEqual(sut.flavorLbl.font, UIFont.italicSystemFont(ofSize: 16))
    }
    
    func testViewDidLoadShouldSetupCollectionView() {
        let viewModel = PokemonDetailViewModelSpy()
        let sut = PokemonDetailVC(viewModel: viewModel)
        
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.pokemonCollectionView.delegate)
    }
    
    func testViewDidLoadShouldShowRecommendedPokemonCellWhenPokemonNotEmpty() {
        let viewModel = PokemonDetailViewModelSpy()
        let sut = PokemonDetailVC(viewModel: viewModel)
        
        sut.loadViewIfNeeded()
        var pokemons: [Pokemon] = []
        for _ in 0...5 {
            let legalities = Legalities(unlimited: Expanded.legal, expanded: nil)
            let image = Set(id: "", name: "", series: "", printedTotal: 0, total: 0, legalities: legalities, ptcgoCode: nil, releaseDate: "", updatedAt: "", images: SetImages(symbol: "", logo: ""))
            let pokemon = Pokemon(id: "", name: "", supertype: "", subtypes: [], level: nil, hp: "", types: [], evolvesFrom: nil, abilities: nil, attacks: nil, weaknesses: nil, resistances: nil, retreatCost: nil, convertedRetreatCost: nil, datumSet: image, number: nil, artist: nil, rarity: nil, flavorText: nil, nationalPokedexNumbers: [], legalities: legalities, images: DatumImages(small: "", large: ""), tcgplayer: nil, cardmarket: nil, evolvesTo: nil, rules: nil)
            pokemons.append(pokemon)
        }
        viewModel.setRecommendedPokemon(pokemons)
        sut.pokemonCollectionView.dataSource?.collectionView(sut.pokemonCollectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(sut.pokemonCollectionView.numberOfItems(inSection: 0), pokemons.count)
    }
    
    func testViewDidLoadShouldShowEmptyCellWhenPokemonEmpty() {
        let viewModel = PokemonDetailViewModelSpy()
        let sut = PokemonDetailVC(viewModel: viewModel)
        
        sut.loadViewIfNeeded()
        viewModel.setRecommendedPokemon([])
        
        XCTAssertEqual(sut.pokemonCollectionView.numberOfItems(inSection: 0), 0)
    }
    
    func testViewDidLoadShouldShowPokemonDetailWhenModelSelected() {
        let viewModel = PokemonDetailViewModelSpy()
        let sut = PokemonDetailVC(viewModel: viewModel)        
        let coordinator = CoordinatorSpy()
        sut.coordinator = coordinator
        
        sut.loadViewIfNeeded()
        let legalities = Legalities(unlimited: Expanded.legal, expanded: nil)
        let image = Set(id: "", name: "", series: "", printedTotal: 0, total: 0, legalities: legalities, ptcgoCode: nil, releaseDate: "", updatedAt: "", images: SetImages(symbol: "", logo: ""))
        let pokemon = Pokemon(id: "", name: "", supertype: "", subtypes: [], level: nil, hp: "", types: [], evolvesFrom: nil, abilities: nil, attacks: nil, weaknesses: nil, resistances: nil, retreatCost: nil, convertedRetreatCost: nil, datumSet: image, number: nil, artist: nil, rarity: nil, flavorText: nil, nationalPokedexNumbers: [], legalities: legalities, images: DatumImages(small: "", large: ""), tcgplayer: nil, cardmarket: nil, evolvesTo: nil, rules: nil)
        viewModel.setRecommendedPokemon([pokemon])

        sut.pokemonCollectionView.delegate?.collectionView?(sut.pokemonCollectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

        XCTAssertTrue(coordinator.pokemonDetailVCCalled)
    }
    
    func testViewDidLoadShouldBindNameLbl() {
        let viewModel = PokemonDetailViewModelSpy()
        let sut = PokemonDetailVC(viewModel: viewModel)

        sut.loadViewIfNeeded()
        viewModel.setName("pikachu")
        
        XCTAssertEqual(sut.nameLbl.text, "pikachu")
    }
    
    func testViewDidLoadShouldBingTypeLbl() {
        let viewModel = PokemonDetailViewModelSpy()
        let sut = PokemonDetailVC(viewModel: viewModel)

        sut.loadViewIfNeeded()
        viewModel.setType("Lightning", hp: "100")

        XCTAssertEqual(sut.typeLbl.text, "Lightning (HP 100)")
    }
    
    func testViewDidLoadShouldBindSubtypeLbl() {
        let viewModel = PokemonDetailViewModelSpy()
        let sut = PokemonDetailVC(viewModel: viewModel)

        sut.loadViewIfNeeded()
        viewModel.setSubtype(subtype: "Stage 1", supertype: "Pokemon")

        XCTAssertEqual(sut.subtypesLbl.text, "Pokemon - Stage 1")
    }
    
    func testViewDidLoadShouldBindFlavorLbl() {
        let viewModel = PokemonDetailViewModelSpy()
        let sut = PokemonDetailVC(viewModel: viewModel)

        sut.loadViewIfNeeded()
        viewModel.setFlavor("Lorem ipsum dolor")
        
        XCTAssertEqual(sut.flavorLbl.text, "Lorem ipsum dolor")
    }
    
    func testViewDidLoadShouldShowPokemonImageWhenTapThumbnail() {
        let viewModel = PokemonDetailViewModelSpy()
        let sut = PokemonDetailVC(viewModel: viewModel)
        let coordinator = CoordinatorSpy()
        sut.coordinator = coordinator

        sut.loadViewIfNeeded()
        viewModel.didTapThumbnailImg()

        XCTAssertTrue(coordinator.pokemonImageVCCalled)
    }
    
    func testViewDidLoadShouldFetchRecommendedPokemon() {
        let viewModel = PokemonDetailViewModelSpy()
        let sut = PokemonDetailVC(viewModel: viewModel)

        sut.loadViewIfNeeded()
        viewModel.setType("Lightning", hp: "100")
        viewModel.setSubtype(subtype: "Stage 1", supertype: "Pokemon")

        XCTAssertTrue(viewModel.fetchRecommendedPokemonsCalled)
    }
}
