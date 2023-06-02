//
//  PokemonCardViewModel.swift
//  Pokemons
//
//  Created by Cahyanto Setya Budi on 01/06/23.
//

import Foundation

struct PokemonCardViewModel {
    private let thumbnailUrlString: String
    
    init(thumbnailUrl: String) {
        self.thumbnailUrlString = thumbnailUrl
    }
    
    var thumbnailUrl: URL? {
        URL(string: thumbnailUrlString)
    }
}
