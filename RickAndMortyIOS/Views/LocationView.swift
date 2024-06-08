//
//  LocationView.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 8/6/24.
//

import UIKit
import RxSwift

final class LocationView: UIView {
    private let viewModel: LocationViewViewModel
    private let disposeBag = DisposeBag()
    private var locations: PaginationResponse<Location> = PaginationResponse.empty
    
    init(frame: CGRect, viewModel: LocationViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupSubviews()
        setupViewConstraints()
        bindViews()
    }
    
    private let locationTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(LocationTableViewCell.self)
        tableView.alpha = 0
        tableView.isHidden = true
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubviews([locationTableView, spinner])
    }
    
    private func setupViewConstraints() {
        locationTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
    
    private func bindViews() {
        locationTableView.delegate = self
        locationTableView.dataSource = self
        
        let input = LocationViewViewModel.Input(
            fetchLocationsStream: .just(())
        )
        
        let output = viewModel.transform(input: input)
        
        output.locationsStream.driveNext { [weak self] locationResponse in
            guard let self else { return }
          
            
            var newIndexPaths = [IndexPath]()
            for item in 0..<locationResponse.results.count {
                newIndexPaths.append(IndexPath(row: item + locations.results.count, section: 0))
            }
            
            self.locationTableView.performBatchUpdates {
                self.locations = PaginationResponse<Location>(
                    results: self.locations.results + locationResponse.results,
                    info: locationResponse.info)
                self.locationTableView.insertRows(at: newIndexPaths, with: .fade)
                if self.locationTableView.alpha == 0 || self.locationTableView.isHidden {
                    UIView.animate(withDuration: 0.4) {
                        self.locationTableView.isHidden = false
                        self.locationTableView.alpha = 1
                    }
                }
            }
        }.disposed(by: disposeBag)
        
        
        output.isLoadingStream.asObservable().bind(to: spinner.rx.isAnimating).disposed(by: disposeBag)
    }
}


extension LocationView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(LocationTableViewCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        let locationCellViewModel = LocationCellViewModel(location: locations.results[indexPath.row])
        cell.configure(with: locationCellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
