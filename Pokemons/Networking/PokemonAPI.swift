//
//  PokemonAPI.swift
//  Pokemons
//
//  Created by Cahyanto Setya Budi on 30/05/23.
//

import Foundation
import Moya

let provider: MoyaProvider<PokemonAPI> = MoyaProvider<PokemonAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])

enum PokemonAPI {
    case getPokemons(body: [String: Any])
}

extension PokemonAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.pokemontcg.io") else {
            fatalError("Base url not configured properly")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getPokemons:
            return "/v2/cards"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPokemons:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getPokemons(let body):
            return .requestParameters(parameters: body, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getPokemons:
            return [:]
        }
    }
}
