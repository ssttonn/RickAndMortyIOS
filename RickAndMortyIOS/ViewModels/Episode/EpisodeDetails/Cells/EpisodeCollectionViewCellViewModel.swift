//
//  EpisodeCollectionViewCellViewModel.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 10/5/24.
//

import Foundation

struct EpisodeInfoCollectionViewCellViewModel {
    private let title: String
    private let value: String
    
    public var infoTitle: String {
        self.title
    }
    
    public var infoValue: String {
        self.value
    }
    
    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}
