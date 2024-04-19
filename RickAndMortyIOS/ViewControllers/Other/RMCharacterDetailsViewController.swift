//
//  CharacterDetailsViewController.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 16/4/24.
//

import UIKit
import RxSwift

final class RMCharacterDetailsViewController: UIViewController {
    
    private let viewModel: CharacterDetailViewModel
    
    private let detailView = CharacterDetailView()
    private let disposeBag = DisposeBag()
    
    init(viewModel: CharacterDetailViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.name
        
        setupSubviews()
        setupViewConstraints()
        visualizeViews()
        bindViews()
    }
    
    private func setupSubviews(){
        view.addSubview(detailView)
    }
    
    private func setupViewConstraints() {
        detailView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    private func visualizeViews() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
    }
    
    @objc
    private func didTapShare() {
        let text = """
        Name: \(viewModel.name)
        Status: \(viewModel.status)
        Species: \(viewModel.species)
        """
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(vc, animated: true)
    }
    
    private func bindViews() {
        let input = CharacterDetailViewModel.Input(
            fetchCharacterStream: .just(())
        )
        
        let output = viewModel.transform(input: input)
        
        output.characterStream.drive(onNext: {[weak self] character in
            guard let self else { return }
           
            
        }).disposed(by: disposeBag)
    }
}
