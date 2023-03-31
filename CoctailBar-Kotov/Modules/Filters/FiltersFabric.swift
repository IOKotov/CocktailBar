//
//  FiltersFabric.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 08.07.2022.
//

import Foundation

class FiltersFabric {

    class func assembleScreen(router: FiltersRouter,
                              categories: [CategoryName],
                              selectedCategories: [String]) -> FiltersViewController {
        let interactor = FiltersInteractor()
        let presenter = FiltersPresenter(router, interactor)
        let viewController = FiltersViewController(
            presenter: presenter,
            categories: categories,
            selectedCategories: selectedCategories
        )
        presenter.viewController = viewController
        return viewController
    }

}
