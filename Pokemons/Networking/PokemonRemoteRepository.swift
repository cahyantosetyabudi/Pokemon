//
//  PokemonRemoteRepository.swift
//  Pokemons
//
//  Created by Cahyanto Setya Budi on 30/05/23.
//

import Foundation

protocol PokemonRepository {
    func getPokemons(keyword: String?, page: Int, pageSize: Int, completion: @escaping (BaseResponse<[Pokemon]>?, Error?) -> Void)
    func getRecommendedPokemons(types: String, subtypes: String, page: Int, pageSize: Int, completion: @escaping (BaseResponse<[Pokemon]>?, Error?) -> Void)
}

final class PokemonRemoteRepository: PokemonRepository {
    func getPokemons(keyword: String?, page: Int, pageSize: Int, completion: @escaping (BaseResponse<[Pokemon]>?, Error?) -> Void) {
        var query: String = ""
        if let keyword {
            let queryName = "name:\(keyword)*"
            query.append(queryName)
        }
        
        let params: [String: Any] = [
            "q": query,
            "page": page,
            "pageSize": pageSize
        ]
        
        provider.request(.getPokemons(body: params)) { result in
            switch result {
            case .success(let response):
                do {
                    let baseResponse = try response.map(BaseResponse<[Pokemon]>.self)
                    completion(baseResponse, nil)
                } catch let error {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getRecommendedPokemons(types: String, subtypes: String, page: Int, pageSize: Int, completion: @escaping (BaseResponse<[Pokemon]>?, Error?) -> Void) {
        let query = "subtypes:\"\(subtypes)\" -types:\"\(types)\""
        let params: [String: Any] = [
            "q": query,
            "page": page,
            "pageSize": pageSize
        ]
        
        provider.request(.getRecommendedPokemons(body: params)) { result in
            switch result {
            case .success(let response):
                do {
                    let baseResponse = try response.map(BaseResponse<[Pokemon]>.self)
                    completion(baseResponse, nil)
                } catch let error {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
