//
//  RMService.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 30/03/2024.
//

import Foundation

final class RMService {
    static let shared = RMService()
    
    private init() {
        
    }
    
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        
    }
}
