//
//  Extensions+UICollectionView.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 19/4/24.
//

import Foundation
import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: String(describing: cellType.reuseIdentifier), for: indexPath) as? T
    }
}
