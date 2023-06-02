//
//  MainCoordinatorTest.swift
//  PokemonsTests
//
//  Created by Cahyanto Setya Budi on 02/06/23.
//

import XCTest
@testable import Pokemons

final class MainCoordinatorTest: XCTestCase {

    func testStartShouldShowHomeVC() {
        let navigationController = UINavigationController()
        let sut = MainCoordinator(navigationController: navigationController)
        
        sut.start()
        
        XCTAssertTrue(navigationController.visibleViewController is HomeVC)
    }
    
    func testShowPokemonDetailVCShouldShowPokemonDetail() {
        let navigationController = UINavigationController()
        let sut = MainCoordinator(navigationController: navigationController)

        let legalities = Legalities(unlimited: Expanded.legal, expanded: nil)
        let image = Set(id: "", name: "", series: "", printedTotal: 0, total: 0, legalities: legalities, ptcgoCode: nil, releaseDate: "", updatedAt: "", images: SetImages(symbol: "", logo: ""))
        let pokemon = Pokemon(id: "", name: "", supertype: "", subtypes: [], level: nil, hp: "", types: [], evolvesFrom: nil, abilities: nil, attacks: nil, weaknesses: nil, resistances: nil, retreatCost: nil, convertedRetreatCost: nil, datumSet: image, number: nil, artist: nil, rarity: nil, flavorText: nil, nationalPokedexNumbers: [], legalities: legalities, images: DatumImages(small: "", large: ""), tcgplayer: nil, cardmarket: nil, evolvesTo: nil, rules: nil)
        sut.showPokemonDetailVC(pokemon: pokemon)
        
        XCTAssertTrue(navigationController.visibleViewController is PokemonDetailVC)

    }
}
