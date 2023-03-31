//
//  FiltersRouter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 08.07.2022.
//

import UIKit

protocol FiltersRouterDelegate: AnyObject {
    func applySelectedFilters(_ categories: [String])
}

final class FiltersRouter: BaseRouter {

    private let categories: [CategoryName]
    private let selectedCategories: [String]

    weak var delegate: FiltersRouterDelegate?

    init(categories: [CategoryName],
         selectedCategories: [String],
         navigationController: UINavigationController) {
        self.categories = categories
        self.selectedCategories = selectedCategories
        super.init(navigationController: navigationController)
    }

    override func start() {
        guard let navigationController = navigationController else { return }
        let viewController = FiltersFabric.assembleScreen(
            router: self, categories: categories, selectedCategories: selectedCategories
        )
        navigationController.pushViewController(viewController, animated: true)
    }

}

// MARK: - Routing Methods

extension FiltersRouter {

    func applySelectedCategories(_ categories: [String]) {
        guard let navigationController = navigationController, let delegate = delegate else { return }
        delegate.applySelectedFilters(categories)
        navigationController.popViewController(animated: true)
    }

}
