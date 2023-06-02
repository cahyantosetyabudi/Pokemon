//
//  BaseResponse.swift
//  Pokemons
//
//  Created by Cahyanto Setya Budi on 02/06/23.
//

import Foundation

struct BaseResponse<T>: Codable where T: Codable {
    let data: T?
    let page, pageSize, count, totalCount: Int
}
