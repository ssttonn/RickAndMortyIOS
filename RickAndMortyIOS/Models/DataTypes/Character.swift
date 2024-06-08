//
//  Character.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 30/03/2024.
//

import Foundation

struct Character: Codable, Equatable, Hashable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: CharaterGender
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.status == rhs.status && lhs.species == rhs.species && lhs.type == rhs.type && lhs.location == rhs.location && lhs.image == rhs.image && lhs.episode == rhs.episode && lhs.url == rhs.url && lhs.created == rhs.created
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(status)
        hasher.combine(species)
        hasher.combine(type)
        hasher.combine(gender)
        hasher.combine(origin)
        hasher.combine(location)
        hasher.combine(image)
        hasher.combine(episode)
        hasher.combine(url)
        hasher.combine(created)
    }
}

struct Location: Codable, Hashable, Equatable {
    let id: Int
    let name: String
    let url: String
    let dimension: String
    let type: String
    let residents: [String]
    let created: String
    
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.url == rhs.url && lhs.dimension == rhs.dimension && lhs.type == rhs.type && lhs.residents == rhs.residents && lhs.created == rhs.created
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(url)
        hasher.combine(dimension)
        hasher.combine(type)
        hasher.combine(residents)
        hasher.combine(created)
    }
}

enum CharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown
}

enum CharaterGender: String, Codable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown
}
