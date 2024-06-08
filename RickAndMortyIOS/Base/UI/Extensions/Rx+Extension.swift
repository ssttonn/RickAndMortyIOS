//
//  Rx+Extension.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 28/4/24.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    @inline(__always)
    public func mapToVoid() -> Observable<Void> {
        map { _ in }
    }
    
    @inline(__always)
    public func doNext(_ onNext: ((Self.Element) throws -> Void)?) -> Observable<Self.Element> {
        self.do(onNext: onNext)
    }
    
    @inline(__always)
    public func subscribeNext(_ onNext: ((Self.Element) -> Void)?) -> Disposable {
        subscribe(onNext: onNext)
    }
    
    @inline(__always)
    public func onError(_ onError: ((Error) throws -> Void)?) -> Observable<Self.Element> {
        self.do(onError: onError)
    }
    
}

extension Driver {
    public func mapToVoid() -> Driver<Void> {
        map { _ in
            ()
        }
        .asDriver(onErrorDriveWith: .empty())
    }
}

extension SharedSequenceConvertibleType where Self.SharingStrategy == RxCocoa.DriverSharingStrategy {
    @inline(__always)
    public func driveNext(_ onNext: ((Self.Element) -> Void)?) -> Disposable {
        drive(onNext: onNext)
    }

    @inline(__always)
    public func doNext(_ onNext: ((Self.Element) -> Void)?) -> SharedSequence<DriverSharingStrategy, Self.Element> {
        self.do(onNext: onNext)
    }
}
