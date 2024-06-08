//
//  CharacterCollectionViewCellViewModel.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 6/4/24.
//

import Foundation


struct CharacterCollectionViewCellViewModel {
    private let character: Character
    
    init(
        character: Character
    ) {
        self.character = character
    }
    
    public var characterStatusText: String {
        "Status: \(self.character.status.rawValue)"
    }
    
    public var currentCharacter: Character {
        self.character
    }
    
    public var name: String {
        self.character.name
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let characterImageUrl = URL(string: character.image) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        ImageLoaderManager.shared.downloadImage(characterImageUrl, completion: completion)
    }
}
