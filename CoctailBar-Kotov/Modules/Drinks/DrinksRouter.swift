//
//  DrinksRouter.swift
//  CoctailBar-Kotov
//
//  Created by Dmitry Surkov on 07.07.2022.
//

import UIKit

protocol DrinksRouterDelegate: AnyObject {
    func updateSelectedCategories(_ categories: [String])
}

final class DrinksRouter: BaseRouter {

    private let drinksService = DrinksNetworkService()

    weak var delegate: DrinksRouterDelegate?

    override func start() {
        let viewController = DrinksFabric.assembleScreen(router: self)

        let baseNavigationController = UINavigationController(
            rootViewController: viewController
        )
        baseNavigationController.configureTabBarItem(with: .main)
        navigationController = baseNavigationController

        guard let navigationController = navigationController else { return }
        navigationController.setViewControllers([viewController], animated: false)
    }

}

// MARK: - Routing Methods

extension DrinksRouter {

    func openFiltersModule(categories: [CategoryName], selectedCategories: [String]) {
        guard let navigationController = navigationController else { return }
        let router = FiltersRouter(
            categories: categories,
            selectedCategories: selectedCategories,
            navigationController: navigationController
        )
        router.delegate = self
        onNext(childRouter: router)
    }

    func openDetailModule(id: String) {
        guard let navigationController = navigationController else { return }
        let router = DrinkDetailRouter(
            id: id,
            navigationController: navigationController
        )
        onNext(childRouter: router)
    }

}

// MARK: - FiltersRouterDelegate

extension DrinksRouter: FiltersRouterDelegate {

    func applySelectedFilters(_ categories: [String]) {
        guard let delegate = delegate else { return }
        delegate.updateSelectedCategories(categories)
    }

}
