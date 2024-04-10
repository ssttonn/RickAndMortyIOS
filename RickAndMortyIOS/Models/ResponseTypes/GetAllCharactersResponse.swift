//
//  GetAllCharactersResponse.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 6/4/24.
//

import Foundation
 
struct GetAllCharactersResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let results: [Character]
    let info: Info
}

