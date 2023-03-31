//
//  FavoritesRouter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import UIKit

final class FavoritesRouter: BaseRouter {

    init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }

    override func start() {
        guard let navigationController = navigationController else { return }
        let viewController = FavoritesFabric.assembleScreen(router: self)
        navigationController.pushViewController(viewController, animated: true)
    }

}

// MARK: - Routing Methods

extension FavoritesRouter {

    func openDetailModule(id: String) {
        guard let navigationController = navigationController else { return }
        let router = DrinkDetailRouter(
            id: id,
            navigationController: navigationController
        )
        onNext(childRouter: router)
    }

    func openDrinksModule() {
        navigationController?.tabBarController?.selectedIndex = TabBarController.TabItem.main.rawValue
    }

}
