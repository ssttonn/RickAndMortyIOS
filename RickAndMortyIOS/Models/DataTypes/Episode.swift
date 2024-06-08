//
//  Episode.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 30/03/2024.
//

import Foundation

struct Episode: Codable, Equatable, Hashable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    static func == (lhs: Episode, rhs: Episode) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.air_date == rhs.air_date && lhs.episode == rhs.episode && lhs.characters == rhs.characters && lhs.url == rhs.url && lhs.created == rhs.created
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(air_date)
        hasher.combine(episode)
        hasher.combine(characters)
        hasher.combine(url)
        hasher.combine(created)
    }
}
