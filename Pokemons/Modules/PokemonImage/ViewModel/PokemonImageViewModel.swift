//
//  PokemonImageViewModel.swift
//  Pokemons
//
//  Created by Cahyanto Setya Budi on 01/06/23.
//

import Foundation
import RxCocoa

protocol PokemonImageViewModelProtocol {
    var imageUrl: Driver<URL> { get }
}

final class PokemonImageViewModel: PokemonImageViewModelProtocol {
    private let imageUrlString: BehaviorRelay<String>
    
    var imageUrl: Driver<URL> {
        imageUrlString
            .compactMap({ URL(string: $0) })
            .asDriver(onErrorDriveWith: .empty())
    }
    
    init(imageUrlString: String) {
        self.imageUrlString = .init(value: imageUrlString)
    }
}
