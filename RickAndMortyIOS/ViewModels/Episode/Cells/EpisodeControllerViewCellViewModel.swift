//
//  EpisodeCollectionViewCellViewModel.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 28/4/24.
//

import Foundation


struct EpisodeCollectionViewCellViewModel {
    private let episodeName: String
    private let airDate: String
    private let season: String
    
    init(
        episodeName: String,
        airDate: String,
        season: String
    ) {
        self.episodeName = episodeName
        self.airDate = airDate
        self.season = season
    }
    
    public var episodeTitle: String {
        self.episodeName
    }
    
    public var episodeSeason: String {
        self.season
    }
    
    public var episodeAirDate: String {
        self.airDate
    }
}
