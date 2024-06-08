//
//  SettingOption.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 11/5/24.
//

import Foundation
import UIKit

enum SettingOption: CaseIterable {
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCodes
    
    var targetUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https://sstonn.io")
        case .terms:
            return URL(string: "https://sstonn.io/terms")
        case .privacy:
            return URL(string: "https://sstonn.io/privacy")
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com/documentation")
        case .viewSeries:
            return URL(string: "https://sstonn.io/courses")
        case .viewCodes:
            return URL(string: "https://sstonn.io/codes")
        }
    }
    
    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Terms of Service"
        case .privacy:
            return "Privacy Policy"
        case .apiReference:
            return "API Reference"
        case .viewSeries:
            return "View Series"
        case .viewCodes:
            return "View Codes"
        }
    }
    
    var imageContainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemYellow
        case .contactUs:
            return .systemBlue
        case .terms:
            return .systemGreen
        case .privacy:
            return .systemPink
        case .apiReference:
            return .systemPurple
        case .viewSeries:
            return .systemOrange
        case .viewCodes:
            return .systemRed
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star")
        case .contactUs:
            return UIImage(systemName: "envelope")
        case .terms:
            return UIImage(systemName: "doc.text")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "book")
        case .viewSeries:
            return UIImage(systemName: "tv")
        case .viewCodes:
            return UIImage(systemName: "barcode")
        }
    }
}
