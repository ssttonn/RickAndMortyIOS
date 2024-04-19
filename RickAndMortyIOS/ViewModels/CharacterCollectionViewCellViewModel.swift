//
//  CharacterCollectionViewCellViewModel.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 6/4/24.
//

import Foundation


struct CharacterCollectionViewCellViewModel {
    private let characterName: String
    private let characterStatus: CharacterStatus
    private let characterImageUrl: URL?
    
    init(
        characterName: String,
        characterStatus: CharacterStatus,
        characterImageUrl: URL?
    ) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }
    
    public var characterStatusText: String {
        "Status: \(characterStatus.rawValue)"
    }
    
    public var name: String {
        self.characterName
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        ImageLoaderManager.shared.downloadImage(characterImageUrl, completion: completion)
    }
}
