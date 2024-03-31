//
//  RMCharacterViewController.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 30/03/2024.
//

import UIKit

final class RMCharacterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        let request = RMRequest(
            endpoint: .character,
            pathComponents: ["1"],
            queryParameters: [
                URLQueryItem(name: "name", value: "rick"),
                URLQueryItem(name: "status", value: "alive")
            ]
        )
        RMService.shared.execute(request, expecting: String.self) { result in
            
            
        }
    }
}
