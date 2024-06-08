//
//  PaginationResponse.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 28/4/24.
//

import Foundation

struct PaginationResponse<T>: Codable where T: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let results: [T]
    let info: Info
    
    static var empty: PaginationResponse {
        return PaginationResponse(results: [], info: Info(count: 0, pages: 0, next: "", prev: ""))
    }
}
