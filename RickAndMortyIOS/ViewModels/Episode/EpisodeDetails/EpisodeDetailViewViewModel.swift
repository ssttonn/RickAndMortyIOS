//
//  EpisodeDetailViewViewModel.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 10/5/24.
//

import Foundation
import RxSwift
import RxCocoa

struct EpisodeDetailViewViewModel {
    private let episode: Episode
    
    init(episode: Episode) {
        self.episode = episode
    }
    
    enum SectionType {
        case information(viewModels: [EpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [CharacterCollectionViewCellViewModel])
    }
    
    struct Input {
        let fetchRelatedCharactersStream: Observable<Void>
    }
    
    struct Output {
        let sectionsStream: Driver<[SectionType]>
    }
    
    func transform(input: Input) -> Output {
        let sectionsStream = input.fetchRelatedCharactersStream.flatMapLatest { _ -> Observable<[SectionType]> in
            return fetchRelatedCharacters(episode: self.episode).map { characters in
                let informationViewModels = [
                    EpisodeInfoCollectionViewCellViewModel(
                        title: "Name",
                        value: self.episode.name
                    ),
                    EpisodeInfoCollectionViewCellViewModel(
                        title: "Air Date",
                        value: episode.air_date
                    ),
                    EpisodeInfoCollectionViewCellViewModel(
                        title: "Episode", 
                        value: episode.episode
                    ),
                    EpisodeInfoCollectionViewCellViewModel(
                        title: "Created",
                        value: episode.created
                    )
                ]
                let characterViewModels = characters.map { 
                    CharacterCollectionViewCellViewModel(character: $0)
                }
                return [
                    .information(viewModels: informationViewModels),
                    .characters(viewModels: characterViewModels)
                ]
            }
        }
        
        return Output(sectionsStream: sectionsStream.asDriver(onErrorJustReturn: []))
    }
    
    func fetchRelatedCharacters(episode: Episode) -> Observable<[Character]> {
        return Observable.create { observer in
            let requests = episode.characters.compactMap { $0.split(separator: "/").last! }.compactMap({RMRequest(endpoint: .character, pathComponents: ["\($0)"])})
            let group = DispatchGroup()
            var characters: [Character] = []
            for request in requests {
                group.enter()
                RMService.shared.execute(request, expecting: Character.self) { result in
                    defer {
                        group.leave()
                    }
                    switch result {
                    case .success(let character):
                        characters.append(character)
                    case .failure(_):
                        break
                    }
                }
            }
            
            group.notify(queue: .main) {
                observer.onNext(characters)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
