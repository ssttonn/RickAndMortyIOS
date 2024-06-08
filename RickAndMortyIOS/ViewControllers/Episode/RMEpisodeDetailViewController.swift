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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
    
    @objc private func didTapShare() {
        shareTapSubject.onNext(())
    }

    private func setupViewConstraints() {
        detailView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
  
    private func visualizeViews() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private let shareTapSubject = PublishSubject<Void>()
    
    private func bindViews(){
        detailView.delegate = self
        
        let input = EpisodeDetailViewModel.Input(fetchEpisodeStream: rx.viewDidAppear.mapToVoid().take(1))
        
        let output = viewModel.transform(input: input)
        
        output.episodeStream.drive(onNext: { [weak self] episode in
            guard let self else {return}
            detailView.configure(with: EpisodeDetailViewViewModel(episode: episode))
        }).disposed(by: disposeBag)
        
        shareTapSubject.withLatestFrom(output.episodeStream).subscribeNext { [weak self] episode in
            guard let self else {return}
            
            let activityViewController = UIActivityViewController(activityItems: [episode.url], applicationActivities: nil)
            present(activityViewController, animated: true)
        }.disposed(by: disposeBag)
    }
}

extension RMEpisodeDetailViewController: EpisodeDetailViewDelegate {
    func didTapCharacter(character: Character) {
        let characterDetailViewController = RMCharacterDetailsViewController(
            viewModel: CharacterDetailViewModel(character: character)
        )
        navigationController?.pushViewController(characterDetailViewController, animated: true)
    }
}
