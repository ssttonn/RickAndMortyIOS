//
//  EpisodeListViewModel.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 28/4/24.
//

import Foundation
import RxSwift
import RxCocoa

struct EpisodeListViewViewModel {
    
    struct Input {
        let fetchEpisodesStream: Observable<Int>
    }
    
    struct Output {
        let episodeResponseStream: Driver<PaginationResponse<Episode>>
        var isLoadingStream: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let episodeResponseStream = input.fetchEpisodesStream
            .flatMapLatest { page in
                self.fetchEpisodes(page: page)
                    .trackActivity(activityIndicator)
                    .asObservable()
            }
            .share()
        
        return Output(
            episodeResponseStream: episodeResponseStream.asDriver(
                onErrorJustReturn: PaginationResponse<Episode>.empty
            ),
            isLoadingStream: activityIndicator.asDriver(onErrorJustReturn: false)
        )
    }
    
    private func fetchEpisodes(page: Int) -> Observable<PaginationResponse<Episode>> {
        return Observable.create { observer in
            let request = RMRequest(
                endpoint: .episode,
                queryParameters: [URLQueryItem(name: "page", value: "\(page)")]
            )
            RMService.shared.execute(request, expecting: PaginationResponse<Episode>.self) { result in
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
}
