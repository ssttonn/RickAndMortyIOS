//
//  APICacheManager.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 28/4/24.
//

import Foundation

final class APICacheManager {
    static let shared = APICacheManager()
    
    private var cacheDirectory: [RMEndpoint: NSCache<NSString, NSData>] = [:]
    
    private init() {
        RMEndpoint.allCases.forEach { cacheDirectory[$0] = NSCache<NSString, NSData>() }
    }
    
    public func cacheData(for endpoint: RMEndpoint, key: String, data: Data) {
        cacheDirectory[endpoint]?.setObject(data as NSData, forKey: key as NSString)
    }
    
    public func cachedData(for endpoint: RMEndpoint, key: String) -> Data? {
        cacheDirectory[endpoint]?.object(forKey: key as NSString) as Data?
    }
    
    public func clearCache(for endpoint: RMEndpoint) {
        cacheDirectory[endpoint]?.removeAllObjects()
    }
    
    public func clearAllCache() {
        cacheDirectory.forEach { $0.value.removeAllObjects() }
    }
}
