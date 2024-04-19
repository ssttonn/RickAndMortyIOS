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
            guard let requestUrl else {
                observer.onError(URLError(.badURL))
                return Disposables.create()
            }
            
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
