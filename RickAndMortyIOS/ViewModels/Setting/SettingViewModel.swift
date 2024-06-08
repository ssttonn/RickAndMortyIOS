//
//  SettingViewModel.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 11/5/24.
//

import Foundation

struct SettingViewModel {
    let cellViewModels: [SettingCellViewModel]
    let onTabSelected: ((SettingOption) -> Void)?
}
