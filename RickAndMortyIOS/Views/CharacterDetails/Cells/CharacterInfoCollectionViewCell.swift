//
//  CharacterInfoCollectionViewCell.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 19/4/24.
//

import UIKit

class CharacterInfoCollectionViewCell: UICollectionViewCell {
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "globe.americas")
        imageView.tintColor = .label
        
        return imageView
    }()
    
    private lazy var valueStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconImageView, valueLabel])
        stack.axis = .horizontal
        stack.spacing = 14
        return stack
    }()
    
    private let valueContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private let titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemFill
        
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupViewConstraints()
        visualizeViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(viewModel: CharacterInfoCellViewModel) {
        valueLabel.text = viewModel.displayValue
        titleLabel.text = viewModel.type.displayTitle.uppercased()
        iconImageView.image = UIImage(systemName: viewModel.type.iconName)
        iconImageView.tintColor = viewModel.type.tintColor
        titleLabel.textColor = viewModel.type.tintColor
    }
    
    private func setupSubviews() {
        contentView.addSubviews([valueContainerView, titleContainerView])
        valueContainerView.addSubview(valueStack)
        titleContainerView.addSubview(titleLabel)
    }
    
    private func setupViewConstraints() {
        valueStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        
        valueContainerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(titleContainerView.snp.top)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        titleContainerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(32)
        }
      
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func visualizeViews() {
        contentView.clipsToBounds = true
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 16
    }
}
