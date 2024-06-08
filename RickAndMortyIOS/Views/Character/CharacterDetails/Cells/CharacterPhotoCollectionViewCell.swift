//
//  CharacterPhotoCollectionViewCell.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 19/4/24.
//

import UIKit

class CharacterPhotoCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        setupSubviews()
        setupViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(viewModel: CharacterPhotoCellViewModel) {
        viewModel.fetchImage { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            case .failure(_):
                break
            }
        }
    }
    
    private func setupSubviews() {
        contentView.addSubview(imageView)
    }
    
    private func setupViewConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindViews() {
        
    }
}
