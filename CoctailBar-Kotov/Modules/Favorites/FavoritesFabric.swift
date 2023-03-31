//
//  FavoritesFabric.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import UIKit

class FavoritesFabric {

    class func assembleScreen(router: FavoritesRouter) -> FavoritesViewController {
        let interactor = FavoritesInteractor()
        let presenter = FavoritesPresenter(router, interactor)
        let viewController = FavoritesViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }

}
