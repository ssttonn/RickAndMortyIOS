//
//  RMRequest.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 30/03/2024.
//

import Foundation

final class RMRequest {
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    let endpoint: RMEndpoint
    private let pathComponents: [String]
    private let queryParameters: [URLQueryItem]
    
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            for component in pathComponents {
                string += "/\(component)"
            }
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap {
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }.joined(separator: "$")
            string += argumentString
        }
        
        return string
    }
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public init(
        endpoint: RMEndpoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    public init?(url: URL) {
        guard let endpoint = RMEndpoint(rawValue: url.lastPathComponent) else {return nil}
        self.endpoint = endpoint
        self.pathComponents = url.pathComponents.dropFirst(2).map {String($0)}
        self.queryParameters = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
    }
}
