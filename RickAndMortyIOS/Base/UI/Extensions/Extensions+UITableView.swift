//
//  Extensions+UITableView.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 8/6/24.
//

import Foundation
import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: String(describing: cellType.reuseIdentifier), for: indexPath) as? T
    }
}
