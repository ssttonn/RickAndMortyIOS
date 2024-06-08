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
        var fetchCharactersStream: Observable<Int>
    }
    
    struct Output {
        var characterResponseStream: Driver<PaginationResponse<Character>>
        var isLoadingStream: Driver<Bool>
    }
    
    private func fetchCharacters(page: Int) -> Observable<PaginationResponse<Character>> {
        return Observable.create { observer in
            let request = RMRequest(
                endpoint: .character,
                queryParameters: [URLQueryItem(name: "page", value: "\(page)")]
            )
            RMService.shared.execute(request, expecting: PaginationResponse<Character>.self) { result in
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
        let characterResponseStream = input.fetchCharactersStream
            .flatMapLatest { page in
                self.fetchCharacters(page: page)
                    .trackActivity(activityIndicator)
                    .asObservable()
            }
            .share()
        
        return Output(
            characterResponseStream: characterResponseStream.asDriver(
                onErrorJustReturn:
                    PaginationResponse<Character>.empty
            ),
            isLoadingStream: activityIndicator.asDriver(onErrorJustReturn: false)
        )
    }
}
