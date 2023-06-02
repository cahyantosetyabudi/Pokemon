//
//  PokemonCardViewModelTest.swift
//  PokemonsTests
//
//  Created by Cahyanto Setya Budi on 02/06/23.
//

import XCTest
@testable import Pokemons

final class PokemonCardViewModelTest: XCTestCase {

    func testInitShouldAssignThumbnailWhenUrlValid() {
        let sut = PokemonCardViewModel(thumbnailUrl: "http://google.com")
        
        XCTAssertEqual(sut.thumbnailUrl, URL(string: "http://google.com"))
    }
    
    func testInitShouldAssignNilThumbnaikWhenUrlInvalid() {
        let sut = PokemonCardViewModel(thumbnailUrl: "some string")

        XCTAssertNil(sut.thumbnailUrl)
    }
}
