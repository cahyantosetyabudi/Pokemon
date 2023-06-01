//
//  HTTPClient.swift
//  Pokemons
//
//  Created by Cahyanto Setya Budi on 30/05/23.
//

import Foundation

public protocol HTTPClient {
  typealias ResponseResult = Result<Data, Error>
  func get(_ url: URL, responseHandler: @escaping (ResponseResult) -> Void)
}
