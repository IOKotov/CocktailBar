//
//  OrderRouter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 17.11.2022.
//

import UIKit

final class OrderRouter: BaseRouter {

    init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }

    override func start() {
        guard let navigationController = navigationController else { return }
        let viewController = OrderFabric.assembleScreen(router: self)
        navigationController.pushViewController(viewController, animated: true)
    }

}
