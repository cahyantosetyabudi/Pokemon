//
//  PokemonCardCellTest.swift
//  PokemonsTests
//
//  Created by Cahyanto Setya Budi on 02/06/23.
//

import XCTest
@testable import Pokemons

final class PokemonCardCellTest: XCTestCase {

    func testBindViewShouldInitView() {
        let bundle = Bundle(for: PokemonCardCell.self)
        let sut = bundle.loadNibNamed("PokemonCardCell", owner: nil)?.first as? PokemonCardCell
        let viewModel = PokemonCardViewModel(thumbnailUrl: "http://google.com")

        sut?.bind(viewModel: viewModel)

        XCTAssertNotNil(sut?.mainImg)
    }
}
