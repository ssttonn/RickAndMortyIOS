//
//  LocationViewViewModel.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 8/6/24.
//

import Foundation
import RxSwift
import RxCocoa

struct LocationViewViewModel {
    struct Input {
        let fetchLocationsStream: Observable<Void>
    }
    
    struct Output {
        let locationsStream: Driver<PaginationResponse<Location>>
        let isLoadingStream: Driver<Bool>
    }
    
    public func transform(input: Input) -> Output {
        let loadingIndicator = ActivityIndicator()
        
        let locationsStream = input.fetchLocationsStream.flatMapLatest { _ in
            return fetchLocations().trackActivity(loadingIndicator).asObservable()
        }.asDriver(onErrorJustReturn: PaginationResponse.empty)
        
        return Output(
            locationsStream: locationsStream,
            isLoadingStream: loadingIndicator.asDriver(onErrorJustReturn: false)
        )
    }
    
    private func fetchLocations() -> Observable<PaginationResponse<Location>> {
        return Observable.create { observer in
            let request = RMRequest(endpoint: .location)
            
            RMService.shared.execute(request, expecting: PaginationResponse<Location>.self) { result in
                switch result {
                case .success(let response):
                    observer.onNext(response)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
