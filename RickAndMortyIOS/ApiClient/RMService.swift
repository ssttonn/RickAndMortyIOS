//
//  RMService.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 30/03/2024.
//

import Foundation

final class RMService {
    static let shared = RMService()
    
    private let cacheManager = APICacheManager.shared
    
    private init() {
        
    }
    
    enum RMServiceError: Error {
        case badUrl
        case failedToGetData
    }
    
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        if let url = request.url, let cachedData = cacheManager.cachedData(for: request.endpoint, key: url.absoluteString) {
            do {
                let result = try JSONDecoder().decode(type, from: cachedData)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            return
        }
        
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(RMServiceError.badUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) {[weak self] data, _, error in
            guard let data, error == nil, let self else {
                completion(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(type, from: data)
                if let url = request.url {
                    cacheManager.cacheData(for: request.endpoint, key: url.absoluteString, data: data)
                }
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func request(from rawRequest: RMRequest) -> URLRequest? {
        guard let url = rawRequest.url else {return nil}
        let request = URLRequest(url: url)
        return request
    }
}
