//
//  LocationTableViewCell.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 8/6/24.
//

import UIKit

final class LocationTableViewCell: UITableViewCell {
    
    private let locationNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        setupViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: LocationCellViewModel) {
        self.locationNameLabel.text = viewModel.locationName
    }
    
    private func setupSubviews() {
        contentView.addSubviews([locationNameLabel])
    }
    
    private func setupViewConstraints() {
        locationNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
