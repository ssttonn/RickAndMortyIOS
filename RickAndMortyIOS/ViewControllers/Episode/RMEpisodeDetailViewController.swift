//
//  EpisodeDetailViewController.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 28/4/24.
//

import UIKit
import RxSwift

class RMEpisodeDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let detailView: EpisodeDetailView = {
        let view = EpisodeDetailView()
        return view
    }()
    private let viewModel: EpisodeDetailViewModel
    
    init(url: URL?) {
        self.viewModel = EpisodeDetailViewModel(episodeDataUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupViewConstraints()
        bindViews()
        visualizeViews()
    }
    
    private func setupSubviews() {
        view.addSubview(detailView)
    }

    private func setupViewConstraints() {
        detailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func visualizeViews() {
        view.backgroundColor = .systemBackground
    }
    
    private func bindViews(){
        let input = EpisodeDetailViewModel.Input(fetchEpisodeStream: rx.viewDidAppear.mapToVoid().take(1))
        
        let output = viewModel.transform(input: input)
        
        output.episode.drive(onNext: { [weak self] episode in
            guard let self else {return}
            detailView.configure(with: episode)
        }).disposed(by: disposeBag)
    }
}
