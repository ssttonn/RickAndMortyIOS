//
//  EpisodeDetailViewModel.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 28/4/24.
//

import Foundation
import RxSwift
import RxCocoa

struct EpisodeDetailViewModel {
    private let episodeDataUrl: URL?
    
    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }
    
    struct Input {
        let fetchEpisodeStream: Observable<Void>
    }
    
    struct Output {
        let episode: Driver<Episode>
    }
    
    func transform(input: Input) -> Output {
        
        let episodeStream: Driver<Episode?> = input.fetchEpisodeStream
            .flatMap { [episodeDataUrl] _ in
                return Observable<Episode?>.create { observer in
                    guard let episodeDataUrl else {
                        observer.onError(URLError(.badURL))
                        return Disposables.create()
                    }
                    
                    let request = RMRequest(endpoint: .episode, pathComponents: [episodeDataUrl.lastPathComponent])
                    
                    RMService.shared.execute(request, expecting: Episode.self) { result in
                        switch result {
                        case .success(let episode):
                            observer.onNext(episode)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                        }
                    }
                    
                    return Disposables.create()
                }
            }.asDriver(onErrorJustReturn: nil)
        
        return Output(episode: episodeStream.compactMap{$0})
    }
    
  
}
