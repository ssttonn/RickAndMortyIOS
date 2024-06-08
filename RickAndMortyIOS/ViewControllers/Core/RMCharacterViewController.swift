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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        let searchViewController = RMSearchViewController(config: .init(type: .character))
        navigationController?.pushViewController(searchViewController, animated: true)
        
    }
    
    private func setupViewConstraints() {
        characterListView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    private func bindViews() {
        self.characterListView.delegate = self
    }
}

extension RMCharacterViewController: CharacterListViewDelegate {
    func didSelectCharacter(character: Character) {
        let viewModel = CharacterDetailViewModel(character: character)
        let characterDetailViewController = RMCharacterDetailsViewController(viewModel: viewModel)
        characterDetailViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(characterDetailViewController, animated: true)
    }
}
