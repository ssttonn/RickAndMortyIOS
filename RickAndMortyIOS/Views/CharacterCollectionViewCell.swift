//
//  CharacterCollectionViewCell.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 6/4/24.
//

import UIKit

final class CharacterCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "CharacterCollectionViewCell"
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        setupSubviews()
        setupViewConstraints()
        visualizeViews()
        bindViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = ""
        statusLabel.text = ""
    }
    
    private func setupSubviews() {
        contentView.addSubviews([imageView, nameLabel, statusLabel])
        
    }
    
    private func setupViewConstraints() {
        statusLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().offset(8)
            make.bottom.equalTo(statusLabel.snp.top).offset(-3)
        }
        
        imageView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(nameLabel.snp.top).offset(-8)
        }
    }
    
    private func visualizeViews() {
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.secondaryLabel.cgColor
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: -4, height: -4)
        contentView.layer.shadowOpacity = 0.4
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        visualizeViews()
    }
    
    private func bindViews() {
        
    }
    
    public func configure(with viewModel: CharacterCollectionViewCellViewModel) {
        statusLabel.text = viewModel.characterStatusText
        nameLabel.text = viewModel.name
        
        viewModel.fetchImage { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = UIImage(data: data)
                }
            case .failure(_):
                break
            }
        }
    }
}
