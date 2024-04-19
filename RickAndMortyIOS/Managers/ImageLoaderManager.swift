//
//  ImageLoaderManager.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 18/4/24.
//

import Foundation

final class ImageLoaderManager {
    static let shared = ImageLoaderManager()
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private init(){}
    
    func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }
            
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data, error == nil else {
                completion(.failure(error!))
                return
            }
        
            let value = data as NSData
            self.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        
        task.resume()
    }
}
