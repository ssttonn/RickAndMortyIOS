//
//  EpisodeCollectionViewCell.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 28/4/24.
//

import UIKit

class EpisodeCollectionViewCell: UICollectionViewCell {
    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let detailTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupViewConstraints()
        bindViews()
        visualizeViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubviews([episodeLabel, textLabel, detailTextLabel])
    }
    
    private func setupViewConstraints() {
        episodeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(episodeLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        detailTextLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func bindViews() {
        
    }
    
    private func visualizeViews() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
    }
    
    func configure(with viewModel: EpisodeCollectionViewCellViewModel) {
        self.episodeLabel.text = viewModel.episodeSeason
        self.textLabel.text = viewModel.episodeTitle
        self.detailTextLabel.text = viewModel.episodeAirDate
    }
}
