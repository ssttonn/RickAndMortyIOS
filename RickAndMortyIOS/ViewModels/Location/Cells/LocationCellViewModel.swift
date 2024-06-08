//
//  LocationCellViewModel.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 8/6/24.
//

import Foundation

struct LocationCellViewModel: Equatable, Hashable {
    private let location: Location
    
    public var locationName: String {
        self.location.name
    }
    
    public var locationTypse: String {
        self.location.type
    }
    
    public var locationDimension: String {
        self.location.dimension
    }
    
    init(location: Location) {
        self.location = location
    }
    
    static func == (lhs: LocationCellViewModel, rhs: LocationCellViewModel) -> Bool {
        return lhs.location == rhs.location
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(location)
    }
}
