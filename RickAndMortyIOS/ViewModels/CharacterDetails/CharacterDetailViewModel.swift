//
//  CharacterDetailViewModel.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 16/4/24.
//

import Foundation
import RxSwift
import RxCocoa

struct CharacterDetailViewModel {
    
    private let character: Character
    
    init(character: Character){
        self.character = character
    }
    
    public enum SectionType {
        case photo(viewModel: CharacterPhotoCellViewModel)
        case information(viewModels: [CharacterInfoCellViewModel])
        case episodes(viewModels: [CharacterEpisodeCellViewModel])
    }
    
    public lazy var sections: [SectionType] = [
        .photo(viewModel: .init(imageUrl: URL(string: character.image))),
        .information(viewModels: [
            .init(type: .status, value: character.status.rawValue),
            .init(type: .gender, value: character.gender.rawValue),
            .init(type: .type, value: character.type),
            .init(type: .species, value: character.species),
            .init(type: .origin, value: character.origin.name),
            .init(type: .location, value: character.location.name),
            .init(type: .created, value: character.created),
            .init(type: .totalEpisodes, value: character.episode.count.description)
        ]),
        .episodes(viewModels: character.episode.map {episode in
            .init(episodeDataUrl: URL(string: episode))
        })
    ]
    
    public var requestUrl: URL? {
        return URL(string: character.url)
    }
    
    public var name: String {
        return character.name
    }
    
    public var status: String {
        return character.status.rawValue
    }
    
    public var species: String {
        return character.species
    }
    
    struct Input {
        let fetchCharacterStream: Observable<Void>
    }
    
    struct Output {
        let characterStream: Driver<Character>
    }
    
    public func transform(input: Input) -> Output {
        let characterStream = input.fetchCharacterStream.flatMapLatest {
            fetchCharacter()
        }.asDriver(onErrorJustReturn: character)
        return Output(characterStream: characterStream)
    }
    
    private func fetchCharacter() -> Observable<Character> {
        return Observable.create { observer in
            
            let request = RMRequest(
                endpoint: .character,
                pathComponents: [String(character.id)]
            )
            RMService.shared.execute(request, expecting: Character.self) { result in
                switch result {
                case .success(let character):
                    observer.onNext(character)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }.take(1)
    }
}
