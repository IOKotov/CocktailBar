//
//  DrinkDetailFabric.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 13.07.2022.
//

import UIKit

class DrinkDetailFabric {

    class func assembleScreen(router: DrinkDetailRouter, id: String) -> DrinkDetailViewController {
        let interactor = DrinkDetailInteractor(id: id)
        let presenter = DrinkDetailPresenter(router, interactor)
        let viewController = DrinkDetailViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }

}
