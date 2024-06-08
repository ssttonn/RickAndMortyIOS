//
//  SettingCellViewModel.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 11/5/24.
//

import Foundation
import UIKit

struct SettingCellViewModel: Identifiable {
    var id = UUID()
    
    var displayTitle: String {
        type.displayTitle
    }
    
    var image: UIImage? {
        type.iconImage
    }
    
    var imageContainerColor: UIColor {
        type.imageContainerColor
    }
    
    let type: SettingOption
    
    init(
        type: SettingOption
    ) {
        self.type = type
    }
}
