//
//  EpisodeDetailView.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 28/4/24.
//

import UIKit
import RxSwift

protocol EpisodeDetailViewDelegate: AnyObject {
    func didTapCharacter(character: Character)
}

class EpisodeDetailView: UIView {
    public weak var delegate: EpisodeDetailViewDelegate?
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: EpisodeDetailViewViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private var sections = [EpisodeDetailViewViewModel.SectionType]()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //        collectionView.isHidden = true
        //        collectionView.alpha = 0
        //        collectionView.backgroundColor = .systemBackground
        return collectionView
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
        // Add subviews
        addSubviews([collectionView, spinner])
    }
    
    private func setupViewConstraints() {
        // Add constraints
        
        spinner.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.center.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func visualizeViews() {
        // Visualize views
        backgroundColor = .systemRed
        
    }
    
    private func bindViews() {
        // Bind views
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CharacterCollectionViewCell.self)
        collectionView.register(EpisodeInfoCollectionViewCell.self)
    }
    
    private func bindViewModel() {
        // Bind view model
        let input = EpisodeDetailViewViewModel.Input(
            fetchRelatedCharactersStream: .just(())
        )
        let output = viewModel?.transform(input: input)
        
        output?.sectionsStream.drive(onNext: { [weak self] sections in
            guard let self else { return }
            self.sections = sections
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    public func configure(with viewModel: EpisodeDetailViewViewModel) {
        // Configure views
        guard self.viewModel == nil else { return }
        self.viewModel = viewModel
    }
    
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        switch sections[section] {
        case .characters(_):
            return createCharacterLayout()
        case .information(_):
            return createInfoLayout()
        }
    }
    
    func createCharacterLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1))
        )
        
        item.contentInsets = .init(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(260)
            ),
            subitems: [item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func createInfoLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        )
        
        item.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(100)
            ),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}

extension EpisodeDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .characters(let viewModels):
            return viewModels.count
        case .information(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch sections[indexPath.section] {
        case .characters(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(CharacterCollectionViewCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .information(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(EpisodeInfoCollectionViewCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        switch sections[indexPath.section] {
            case .characters(let viewModels):
            let viewModel = viewModels[indexPath.row]
            delegate?.didTapCharacter(character: viewModel.currentCharacter)
            case .information(_):
                break
        }
    }
}
