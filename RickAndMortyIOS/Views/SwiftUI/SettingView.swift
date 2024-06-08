//
//  SettingView.swift
//  RickAndMortyIOS
//
//  Created by sstonn on 15/5/24.
//

import SwiftUI

struct SettingView: View {
    private let viewModel: SettingViewModel
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding(5)
                        .foregroundColor(.white)
                        .background(Color(viewModel.imageContainerColor))
                        .cornerRadius(6)
                }
                Text(viewModel.displayTitle)
                    .padding(.leading, 8)
            }.onTapGesture {
                if let onTabSelected = self.viewModel.onTabSelected {
                    onTabSelected(viewModel.type)
                }
            }
        }
    }
}

#Preview {
    SettingView(
        viewModel: SettingViewModel(
            cellViewModels:
                SettingOption.allCases.map {
            SettingCellViewModel(type: $0)
                }, onTabSelected: nil
    ))
}
