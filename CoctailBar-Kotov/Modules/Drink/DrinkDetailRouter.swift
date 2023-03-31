//
//  DrinkDetailRouter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 13.07.2022.
//

import UIKit

final class DrinkDetailRouter: BaseRouter {

    private let id: String

    init(id: String, navigationController: UINavigationController) {
        self.id = id
        super.init(navigationController: navigationController)
    }

    override func start() {
        guard let navigationController = navigationController else { return }
        let viewController = DrinkDetailFabric.assembleScreen(router: self, id: id)
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.view.backgroundColor = UIColor.clear
        navigationController.pushViewController(viewController, animated: true)
    }

}
