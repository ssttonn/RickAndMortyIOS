//
//  EpisodeInfoCollectionViewCell.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 10/5/24.
//

import UIKit

final class EpisodeInfoCollectionViewCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .right
        label.numberOfLines = 0
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
    
    func configure(with viewModel: EpisodeInfoCollectionViewCellViewModel) {
        titleLabel.text = viewModel.infoTitle
        valueLabel.text = viewModel.infoValue
    }
    
    private func setupSubviews() {
        // Add subviews
        contentView.addSubviews([titleLabel, valueLabel])
    }
    
    private func setupViewConstraints() {
        // Add constraints
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func bindViews() {
        
    }
    
    private func visualizeViews(){
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }
}
