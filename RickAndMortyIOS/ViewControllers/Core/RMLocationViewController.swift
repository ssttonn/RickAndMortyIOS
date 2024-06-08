//
//  RMLocationViewController.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 30/03/2024.
//

import UIKit

final class RMLocationViewController: UIViewController {

    private let locationView: LocationView = {
       let viewModel = LocationViewViewModel()
        
        return LocationView(frame: .zero, viewModel: viewModel)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Locations"
        
        setupSubviews()
        setupViewConstraints()
    }
    
    private func setupSubviews() {
        view.addSubview(locationView)
    }
    
    private func setupViewConstraints() {
        locationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
