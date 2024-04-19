//
//  CharacterListView.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 6/4/24.
//

import UIKit
import RxSwift

protocol CharacterListViewDelegate: AnyObject {
    func didSelectCharacter(character: Character)
}

final class CharacterListView: UIView {
    private let viewModel = CharacterListViewViewModel()
    private let disposeBag = DisposeBag()
    private var characters: GetAllCharactersResponse = GetAllCharactersResponse(results: [], info: GetAllCharactersResponse.Info(count: 0, pages: 0, next: "", prev: ""))
    private var currentPage = 1
    weak var delegate: CharacterListViewDelegate?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.register(
            CharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: CharacterCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            FooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterLoadingCollectionReusableView.identifier
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
    
    private let loadmoreSubject = PublishSubject<Int>()
    
    private func bindViews(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let input = CharacterListViewViewModel.Input(
            fetchCharactersStream: .concat(.just(1), loadmoreSubject.asObservable())
        )
        
        let output = viewModel.transform(input: input)
        
        output.characterResponseStream.drive(onNext: { [weak self] characterResponse in
            guard let self else {return}

            var newIndexPaths = [IndexPath]()
            for item in 0..<characterResponse.results.count {
                newIndexPaths.append(IndexPath(row: item + characters.results.count, section: 0))
            }
            
            self.characters = GetAllCharactersResponse(
                results: self.characters.results + characterResponse.results,
                info: characterResponse.info)
            
            self.collectionView.performBatchUpdates {
                self.collectionView.insertItems(at: newIndexPaths)
                if self.collectionView.alpha == 0 || self.collectionView.isHidden {
                    UIView.animate(withDuration: 0.4) {
                        self.collectionView.isHidden = false
                        self.collectionView.alpha = 1
                    }
                }
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
        characters.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier, for: indexPath) as? CharacterCollectionViewCell else {
            return UICollectionViewCell()
        }
        let character = characters.results[indexPath.row]
        let viewModel = CharacterCollectionViewCellViewModel(
            characterName: character.name,
            characterStatus: character.status,
            characterImageUrl: URL(string: character.image)
        )
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let cellWidth = (bounds.width - 30) / 2
        return CGSize(width: cellWidth, height: cellWidth * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters.results[indexPath.row]
        delegate?.didSelectCharacter(character: character)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter, let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterLoadingCollectionReusableView.identifier, for: indexPath) as? FooterLoadingCollectionReusableView {
            if currentPage < characters.info.pages {
                footerView.startAnimating()
            } else {
                footerView.stopAnimating()
            }
            return footerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 50)
    }
}

extension CharacterListView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height && currentPage < characters.info.pages {
            currentPage += 1
            loadmoreSubject.onNext(currentPage)
        }
    }
}
