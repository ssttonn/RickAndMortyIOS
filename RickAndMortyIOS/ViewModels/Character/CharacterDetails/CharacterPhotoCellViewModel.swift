//
//  CharacterPhotoCellViewModel.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 19/4/24.
//

import Foundation

struct CharacterPhotoCellViewModel {
    public let imageUrl: URL?
    
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        ImageLoaderManager.shared.downloadImage(imageUrl) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
