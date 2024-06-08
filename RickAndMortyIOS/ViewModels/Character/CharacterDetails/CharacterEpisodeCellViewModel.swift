//
//  CharacterEpisodeCellViewModel.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 19/4/24.
//

import Foundation

class CharacterEpisodeCellViewModel {
    let episodeDataUrl: URL?
    private var isFetching = false
    
    private var episode: Episode?
    
    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }
    
    public func fetchEpisode(completion: @escaping (Result<Episode, Error>) -> Void) {
        if let episode {
            completion(.success(episode))
            return
        }
        
        guard !isFetching else {return}
        
        isFetching = true
        guard let episodeDataUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let request = RMRequest(endpoint: .episode, pathComponents: [episodeDataUrl.lastPathComponent])
        
        RMService.shared.execute(request, expecting: Episode.self) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let episode):
                self.episode = episode
                completion(.success(episode))
            case .failure(let error):
                completion(.failure(error))
            }
            isFetching = false
        }
    }
}
