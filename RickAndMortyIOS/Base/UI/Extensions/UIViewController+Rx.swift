//
//  UIViewController+Rx.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 28/4/24.
//

import Foundation
import RxSwift
import UIKit
import RxCocoa

extension Reactive where Base: UIViewController {
    public var viewDidLoad: ControlEvent<Void> {
         let source = methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
         return ControlEvent(events: source)
     }

     public var viewWillAppear: ControlEvent<Bool> {
         let source = methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
         return ControlEvent(events: source)
     }
     public var viewDidAppear: ControlEvent<Bool> {
         let source = methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
         return ControlEvent(events: source)
     }

     public var viewWillDisappear: ControlEvent<Bool> {
         let source = methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
         return ControlEvent(events: source)
     }
     public var viewDidDisappear: ControlEvent<Bool> {
         let source = methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
         return ControlEvent(events: source)
     }

     public var viewWillLayoutSubviews: ControlEvent<Void> {
         let source = methodInvoked(#selector(Base.viewWillLayoutSubviews)).map { _ in }
         return ControlEvent(events: source)
     }
     public var viewDidLayoutSubviews: ControlEvent<Void> {
         let source = methodInvoked(#selector(Base.viewDidLayoutSubviews)).map { _ in }
         return ControlEvent(events: source)
     }

     public var willMoveToParentViewController: ControlEvent<UIViewController?> {
         let source = methodInvoked(#selector(Base.willMove)).map { $0.first as? UIViewController }
         return ControlEvent(events: source)
     }
     public var didMoveToParentViewController: ControlEvent<UIViewController?> {
         let source = methodInvoked(#selector(Base.didMove)).map { $0.first as? UIViewController }
         return ControlEvent(events: source)
     }

     public var didReceiveMemoryWarning: ControlEvent<Void> {
         let source = methodInvoked(#selector(Base.didReceiveMemoryWarning)).map { _ in }
         return ControlEvent(events: source)
     }

     /// Rx observable, triggered when the ViewController appearance state changes (true if the View is being displayed, false otherwise)
     public var isVisible: Observable<Bool> {
         let viewDidAppearObservable = base.rx.viewDidAppear.map { _ in true }
         let viewWillDisappearObservable = base.rx.viewWillDisappear.map { _ in false }
         return Observable<Bool>.merge(viewDidAppearObservable, viewWillDisappearObservable)
     }

     /// Rx observable, triggered when the ViewController is being dismissed
     public var isDismissing: ControlEvent<Bool> {
         let source = sentMessage(#selector(Base.dismiss)).map { $0.first as? Bool ?? false }
         return ControlEvent(events: source)
     }

     public var viewWillAppearAndActive: Observable<Void> {
         viewWillAppear.flatMapLatest { _ -> Observable<Void> in
             switch UIApplication.shared.applicationState {
             case .active:
                 return .just(())
             case .inactive, .background:
                 return UIApplication.shared.rx.applicationDidBecomeActive.mapToVoid().take(1)
             default:
                 return .empty()
             }
         }
     }

     public var viewDidAppearAndActive: Observable<Void> {
         viewDidAppear.flatMapLatest { _ -> Observable<Void> in
             switch UIApplication.shared.applicationState {
             case .active:
                 return .just(())
             case .inactive, .background:
                 return UIApplication.shared.rx.applicationDidBecomeActive.mapToVoid().take(1)
             default:
                 return .empty()
             }
         }
     }
}
