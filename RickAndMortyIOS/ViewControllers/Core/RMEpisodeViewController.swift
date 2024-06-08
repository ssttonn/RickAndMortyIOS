//
//  RMEpisodeViewController.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 30/03/2024.
//

import UIKit

final class RMEpisodeViewController: UIViewController {
    private let episodeListView = EpisodeListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupViewConstraints()
        bindViews()
        visualizeViews()
    }

    private func setupSubviews() {
        view.addSubview(episodeListView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        let searchViewController = RMSearchViewController(config: .init(type: .episode))
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    private func setupViewConstraints() {
        episodeListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindViews() {
        episodeListView.delegate = self
    }
    
    private func visualizeViews() {
        view.backgroundColor = .systemBackground
        title = "Episodes"
    }
}

extension RMEpisodeViewController: EpisodeListViewDelegate {
    func didSelectEpisode(episode: Episode) {
        let episodeDetailViewController = RMEpisodeDetailViewController(url: URL(string: episode.url))
        navigationController?.pushViewController(episodeDetailViewController, animated: true)
    }
}
