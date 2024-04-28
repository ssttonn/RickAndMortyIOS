//
//  CharacterInfoCellViewModel.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 19/4/24.
//

import Foundation
import UIKit

struct CharacterInfoCellViewModel {
    public let type: `Type`
    private let value: String
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = .current
        return dateFormatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = .current
        return dateFormatter
    }()
    
    public var displayValue: String {
        if value.isEmpty {
            return "Unknown"
        }
        if type == .created, let date = CharacterInfoCellViewModel.dateFormatter.date(from: value) {
            return CharacterInfoCellViewModel.shortDateFormatter.string(from: date)
        }
        return value
    }
    
    init(type: `Type`, value: String){
        self.type = type
        self.value = value
    }
    
    enum `Type` {
        case status
        case gender
        case type
        case species
        case origin
        case location
        case created
        case totalEpisodes
        
        var displayTitle: String {
            switch self {
            case .status:
                return "Status"
            case .gender:
                return "Gender"
            case .type:
                return "Type"
            case .species:
                return "Species"
            case .origin:
                return "Origin"
            case .location:
                return "Location"
            case .created:
                return "Created"
            case .totalEpisodes:
                return "Total Episodes"
            }
        }
        
        var iconName: String {
            switch self {
            case .status:
                return "circle.fill"
            case .gender:
                return "person.fill"
            case .created:
                return "calendar"
            case .location:
                return "mappin.and.ellipse"
            case .origin:
                return "arrow.up.right.circle.fill"
            case .species:
                return "staroflife.fill"
            case .totalEpisodes:
                return "tv.fill"
            case .type:
                return "doc.text.fill"
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemBlue
            case .gender:
                return .systemRed
            case .created:
                return .systemPink
            case .type:
                return .systemPurple
            case .species:
                return .systemGreen
            case .origin:
                return .systemOrange
            case .location:
                return .systemYellow
            case .totalEpisodes:
                return .systemMint
            }
        }
    }
    
}


