//
//  RMCharacterViewController.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 30/03/2024.
//

import UIKit
import SnapKit

final class RMCharacterViewController: UIViewController {
    
    private let characterListView = CharacterListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        setupSubviews()
        setupViewConstraints()
        bindViews()
    }
    
    private func setupSubviews() {
        view.addSubview(characterListView)
    }
    
    private func setupViewConstraints() {
        characterListView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    private func bindViews() {
        
    }
}
