//
//  RMSearchViewController.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 29/4/24.
//

import UIKit

class RMSearchViewController: UIViewController {

    struct Config {
        enum `Type` {
            case character
            case location
            case episode
        }
        
        let type: Type
    }
    
    private let config: Config
    
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        setupSubviews()
        setupViewConstraints()
        bindViews()
        visualizeViews()
    }
    
    private func setupSubviews() {
        // Add search bar
    }
    
    private func setupViewConstraints() {
        // Add constraints
    }
    
    private func visualizeViews() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func bindViews() {
        // Bind views
    }

}
