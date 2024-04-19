//
//  Reusable.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 19/4/24.
//

import Foundation

public protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    public static var reuseIdentifier: String {
        String(describing: self)
    }
}

