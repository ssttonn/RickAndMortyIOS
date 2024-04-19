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
    
    static var empty: GetAllCharactersResponse {
        return GetAllCharactersResponse(results: [], info: Info(count: 0, pages: 0, next: "", prev: ""))
    }
}

