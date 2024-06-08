//
//  RMSettingsViewController.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 30/03/2024.
//

import UIKit
import SwiftUI
import SafariServices
import StoreKit

final class RMSettingsViewController: UIViewController {

    private lazy var viewModel = SettingViewModel(
        cellViewModels: SettingOption.allCases.map {
            SettingCellViewModel(type: $0)
        }, onTabSelected: { [weak self] option in
            guard let self else {return}
            if let url = option.targetUrl {
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true)
            } else if option == .rateApp {
                if let windowScene = view.window?.windowScene {
                    SKStoreReviewController.requestReview(in: windowScene)
                }
            }
        }
    )
    
    private lazy var settingSwiftUIController = UIHostingController(
        rootView: SettingView(
            viewModel: viewModel
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
        setupSubviews()
        setupViewConstraints()
        bindViews()
        visualizeViews()
    }
    
    private func setupSubviews() {
        addChild(settingSwiftUIController)
        settingSwiftUIController.didMove(toParent: self)
        
        view.addSubview(settingSwiftUIController.view)
    }
    
    private func setupViewConstraints(){
        settingSwiftUIController.view.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    private func bindViews(){
        
    }
    
    private func visualizeViews(){
        view.backgroundColor = .systemBackground
    }
}
