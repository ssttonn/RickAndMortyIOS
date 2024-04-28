//
//  UIApplication+Rx.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 28/4/24.
//

import Foundation
import RxSwift
import UIKit

public enum AppState: Equatable {
    /**
     The application is running in the foreground.
     */
    case active
    /**
     The application is running in the foreground but not receiving events.
     Possible reasons:
     - The user has opens Notification Center or Control Center
     - The user receives a phone call
     - A system prompt is shown (e.g. Request to allow Push Notifications)
     */
    case inactive
    /**
     The application is in the background because the user closed it.
     */
    case background
    /**
     The application is about to be terminated by the system
     */

    case foreground

    case terminated
}

extension Reactive where Base: UIApplication {
    /**
       Reactive wrapper for `UIApplication.willEnterForegroundNotification`.
       */
      public var applicationWillEnterForeground: Observable<AppState> {
          NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
              .map { _ in
                  .foreground
              }
      }

      /**
       Reactive wrapper for `UIApplication.didBecomeActiveNotification`.
       */
      public var applicationDidBecomeActive: Observable<AppState> {
          NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
              .map { _ in
                  .active
              }
      }

      /**
       Reactive wrapper for `UIApplication.didBecomeActiveNotification`.
       */
      public var applicationDidEnterBackground: Observable<AppState> {
          NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)
              .map { _ in
                  .background
              }
      }

      /**
       Reactive wrapper for `UIApplication.willResignActiveNotification`.
       */
      public var applicationWillResignActive: Observable<AppState> {
          NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification)
              .map { _ in
                  .inactive
              }
      }

      /**
       Reactive wrapper for `UIApplication.willTerminateNotification`.
       */
      public var applicationWillTerminate: Observable<AppState> {
          NotificationCenter.default.rx.notification(UIApplication.willTerminateNotification)
              .map { _ in
                  .terminated
              }
      }

      /**
       Observable sequence of the application's state

       This gives you an observable sequence of all possible application states.

       - returns: Observable sequence of AppStates
       */
      public var appState: Observable<AppState> {
          Observable.of(
              applicationDidBecomeActive,
              applicationWillResignActive,
              applicationWillEnterForeground,
              applicationDidEnterBackground,
              applicationWillTerminate
          )
          .merge()
      }

      /**
       Observable sequence that emits a value whenever the user opens the app

       This is a handy sequence if you want to run some code everytime
       the user opens the app.
       It ignores `applicationDidBecomeActive(_:)` calls when the app was not
       in the background but only in inactive state (because the user
       opened control center or received a call).

       Typical use cases:
       - Track when the user opens the app.
       - Refresh data on app start

       - returns: Observable sequence of Void
       */
      public var didOpenApp: Observable<Void> {
          Observable.of(
              applicationDidBecomeActive,
              applicationDidEnterBackground
          )
          .merge()
          .distinctUntilChanged()
          .filter { $0 == .active }
          .map { _ in
          }
      }
}
