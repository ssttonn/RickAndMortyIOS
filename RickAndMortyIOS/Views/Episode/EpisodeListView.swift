//
//  EpisodeListView.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 28/4/24.
//

import UIKit
import RxSwift

protocol EpisodeListViewDelegate: AnyObject {
    func didSelectEpisode(episode: Episode)
}

final class EpisodeListView: UIView {
    private let viewModel = EpisodeListViewViewModel()
    private let disposeBag = DisposeBag()
    private var episodes: PaginationResponse<Episode> = PaginationResponse<Episode>.empty
    private var currentPage = 1
    weak var delegate: EpisodeListViewDelegate?
    
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
        collectionView.register(
            EpisodeCollectionViewCell.self
        )
        collectionView.register(
            FooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterLoadingCollectionReusableView.identifier
        )
        
        let input = EpisodeListViewViewModel.Input(
            fetchEpisodesStream: .concat(.just(1), loadmoreSubject.asObservable())
        )
        
        let output = viewModel.transform(input: input)
        
        output.episodeResponseStream.driveNext { [weak self] episodeResponse in
            guard let self else {return}

            var newIndexPaths = [IndexPath]()
            for item in 0..<episodeResponse.results.count {
                newIndexPaths.append(IndexPath(row: item + episodes.results.count, section: 0))
            }
            
            self.collectionView.performBatchUpdates {
                self.episodes = PaginationResponse<Episode>(
                    results: self.episodes.results + episodeResponse.results,
                    info: episodeResponse.info)
                self.collectionView.insertItems(at: newIndexPaths)
                if self.collectionView.alpha == 0 || self.collectionView.isHidden {
                    UIView.animate(withDuration: 0.4) {
                        self.collectionView.isHidden = false
                        self.collectionView.alpha = 1
                    }
                }
            }
            
          
        }.disposed(by: disposeBag)
        
        output.isLoadingStream.asObservable().bind(to: spinner.rx.isAnimating).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
}

extension EpisodeListView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        episodes.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            EpisodeCollectionViewCell.self,
            for: indexPath
        ) else {
            return UICollectionViewCell()
        }
        let episode = episodes.results[indexPath.row]
        let viewModel = EpisodeCollectionViewCellViewModel(
            episodeName: episode.name,
            airDate: episode.air_date,
            season: episode.episode
        )
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let cellWidth = (bounds.width - 20)
        return CGSize(width: cellWidth, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes.results[indexPath.row]
        delegate?.didSelectEpisode(episode: episode)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter, let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterLoadingCollectionReusableView.identifier, for: indexPath) as? FooterLoadingCollectionReusableView {
            if currentPage < episodes.info.pages {
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

extension EpisodeListView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height && currentPage < episodes.info.pages {
            currentPage += 1
            loadmoreSubject.onNext(currentPage)
        }
    }
}
