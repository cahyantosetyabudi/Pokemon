//
//  Pokemon.swift
//  Pokemons
//
//  Created by Cahyanto Setya Budi on 02/06/23.
//

import Foundation

struct Pokemon: Codable {
    let id, name: String
    let supertype: String
    let subtypes: [String]
    let level: String?
    let hp: String
    let types: [String]
    let evolvesFrom: String?
    let abilities: [Ability]?
    let attacks: [Attack]?
    let weaknesses: [Resistance]?
    let resistances: [Resistance]?
    let retreatCost: [String]?
    let convertedRetreatCost: Int?
    let datumSet: Set
    let number, artist: String?
    let rarity, flavorText: String?
    let nationalPokedexNumbers: [Int]
    let legalities: Legalities
    let images: DatumImages
    let tcgplayer: Tcgplayer?
    let cardmarket: Cardmarket?
    let evolvesTo, rules: [String]?

    enum CodingKeys: String, CodingKey {
        case id, name, supertype, subtypes, level, hp, types, evolvesFrom, abilities, attacks, weaknesses, resistances, retreatCost, convertedRetreatCost
        case datumSet = "set"
        case number, artist, rarity, flavorText, nationalPokedexNumbers, legalities, images, tcgplayer, cardmarket, evolvesTo, rules
    }
}

struct Ability: Codable {
    let name, text, type: String
}

struct Attack: Codable {
    let name: String
    let cost: [String]
    let convertedEnergyCost: Int
    let damage, text: String
}

struct Cardmarket: Codable {
    let url: String
    let updatedAt: String
    let prices: [String: Double?]?
}

struct Set: Codable {
    let id, name, series: String
    let printedTotal, total: Int
    let legalities: Legalities
    let ptcgoCode: String?
    let releaseDate, updatedAt: String
    let images: SetImages
}

struct SetImages: Codable {
    let symbol, logo: String
}

struct Legalities: Codable {
    let unlimited: Expanded
    let expanded: Expanded?
}

enum Expanded: String, Codable {
    case legal = "Legal"
}

struct DatumImages: Codable {
    let small, large: String
}

struct Resistance: Codable {
    let type, value: String
}

struct Tcgplayer: Codable {
    let url: String
    let updatedAt: String
    let prices: Prices?
}

struct Prices: Codable {
    let holofoil, reverseHolofoil, normal: Holofoil?
}

struct Holofoil: Codable {
    let low, mid, high, market: Double?
    let directLow: Double?
}
