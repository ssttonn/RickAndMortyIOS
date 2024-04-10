//
//  CharacterListViewViewModel.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 6/4/24.
//

import Foundation
import RxSwift
import RxCocoa

struct CharacterListViewViewModel {
    struct Input {
        var fetchCharactersStream: Observable<Void>
    }
    
    struct Output {
        var charactersStream: Driver<[CharacterCollectionViewCellViewModel]>
        var isLoadingStream: Driver<Bool>
    }
    
    private func fetchAllCharacters() -> Observable<GetAllCharactersResponse> {
        return Observable.create { observer in
            let request = RMRequest(
                endpoint: .character
            )
            RMService.shared.execute(request, expecting: GetAllCharactersResponse.self) { result in
                switch result {
                case .success(let response):
                    observer.onNext(response)
                    observer.onCompleted()
                case.failure(let error):
                    observer.onError(error)
                }
                
            }
            return Disposables.create()
        }
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        
        let characterResponseStream = input.fetchCharactersStream.flatMapLatest {
            fetchAllCharacters()
        }.share().trackActivity(activityIndicator)
        
        return Output(
            charactersStream: characterResponseStream.map{$0.results}.map {
                $0.map {CharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image)
                )}
            }.asDriver(onErrorJustReturn: []),
            isLoadingStream: activityIndicator.asDriver(onErrorJustReturn: false)
        )
    }
}
