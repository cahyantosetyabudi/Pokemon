//
//  URLSessionHTTPClientError.swift
//  Pokemons
//
//  Created by Cahyanto Setya Budi on 30/05/23.
//

import Foundation

public enum URLSessionHTTPClientError: Error {
  case error(Error)
  case unknown(Data?, URLResponse?, Error?)
}
