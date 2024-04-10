//
//  CharacterListView.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 6/4/24.
//

import UIKit
import RxSwift

final class CharacterListView: UIView {
    private let viewModel = CharacterListViewViewModel()
    private let disposeBag = DisposeBag()
    private var characters: [CharacterCollectionViewCellViewModel] = []
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.register(
            CharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: CharacterCollectionViewCell.cellIdentifier
        )
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupViewConstraints()
        bindViews()
    }
    
    private func setupSubviews() {
        addSubviews([collectionView, spinner])
    }
    
    private func setupViewConstraints() {
        spinner.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.center.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindViews(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let input = CharacterListViewViewModel.Input(fetchCharactersStream: .just(()))
        
        let output = viewModel.transform(input: input)
        output.charactersStream.drive(onNext: { [weak self] characters in
            guard let self else {return}
            self.characters = characters
            collectionView.reloadData()
            
            UIView.animate(withDuration: 0.4) {
                self.collectionView.isHidden = false
                self.collectionView.alpha = 1
            }
        }).disposed(by: disposeBag)
        
        output.isLoadingStream.asObservable().bind(to: spinner.rx.isAnimating).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
}

extension CharacterListView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier, for: indexPath) as? CharacterCollectionViewCell else {
            return UICollectionViewCell()
        }

        let viewModel = characters[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let cellWidth = (bounds.width - 30) / 2
        return CGSize(width: cellWidth, height: cellWidth * 1.5)
    }
}
