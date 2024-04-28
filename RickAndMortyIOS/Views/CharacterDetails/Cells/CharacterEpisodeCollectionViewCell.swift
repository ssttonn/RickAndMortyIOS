//
//  CharacterEpisodeCollectionViewCell.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 19/4/24.
//

import UIKit

class CharacterEpisodeCollectionViewCell: UICollectionViewCell {
    private let seasonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .light)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        seasonLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
    }
    
    func configure(viewModel: CharacterEpisodeCellViewModel) {
        viewModel.fetchEpisode { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let episode):
               DispatchQueue.main.async {
                    self.seasonLabel.text = "Season \(episode.episode)"
                    self.nameLabel.text = episode.name
                    self.airDateLabel.text = episode.air_date
                }
            case .failure(let error): break
                // Handle error
            }
        }
    }
    
    private func setupSubviews() {
        contentView.addSubviews([seasonLabel, nameLabel, airDateLabel])
    }
    
    private func setupViewConstraints() {
        seasonLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(10)
            make.top.equalTo(contentView).offset(10)
            
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(seasonLabel.snp.bottom).offset(8)
            make.left.equalTo(seasonLabel)
        }
        airDateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.equalTo(seasonLabel)
        }
    }
    
    private func visualizeViews() {
        contentView.backgroundColor = .quaternarySystemFill
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    private func bindViews() {
        
    }
    
}
