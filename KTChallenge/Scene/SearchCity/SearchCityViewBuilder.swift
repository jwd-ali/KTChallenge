//
//  SearchCityViewBuilder.swift
//  KTChallenge
//
//  Created by Jawad Ali on 03/05/2021.
//

import UIKit
final class SearchCityViewBuilder {
    func build() -> UINavigationController {
        let repository = SearchRepository()
        let viewModel = SearchCityViewModel(repository: repository)
        let controller = SearchCityViewController(viewModel: viewModel)
        
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.isTranslucent = false
        return navigationController
    }
}
