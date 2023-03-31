//
//  DrinksFabric.swift
//  CoctailBar-Kotov
//
//  Created by Dmitry Surkov on 07.07.2022.
//

import UIKit

class DrinksFabric {

    class func assembleScreen(router: DrinksRouter) -> DrinksViewController {
        let interactor = DrinksInteractor()
        let presenter = DrinksPresenter(router, interactor)
        router.delegate = presenter

        let viewController = DrinksViewController(presenter)
        presenter.viewController = viewController
        return viewController
    }

}
