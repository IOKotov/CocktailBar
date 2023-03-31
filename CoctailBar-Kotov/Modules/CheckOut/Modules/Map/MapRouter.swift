//
//  MapRouter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 25.10.2022.
//

import UIKit

final class MapRouter: BaseRouter {

    init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }

    override func start() {
        guard let navigationController = navigationController else { return }
        let viewController = MapFabric.assembleScreen(router: self)
        let presentingNavigationController = UINavigationController(rootViewController: viewController)
        navigationController.present(presentingNavigationController, animated: true)
    }

    func dismiss() {
        guard let navigationController = navigationController else { return }
        navigationController.dismiss(animated: true)
    }

}
