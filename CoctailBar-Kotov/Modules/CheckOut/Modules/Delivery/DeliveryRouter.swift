//
//  DeliveryRouter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 26.10.2022.
//

import UIKit

final class DeliveryRouter: BaseRouter {

    private let checkoutDelegate: DeliveryPresenterDelegate

    init(navigationController: UINavigationController, delegate: DeliveryPresenterDelegate) {
        checkoutDelegate = delegate
        
        super.init(navigationController: navigationController)
    }

    override func start() {
        guard let navigationController = navigationController else { return }
        let viewController = DeliveryFabric.assembleScreen(router: self, delegate: checkoutDelegate)
        let presentingNavigationController = UINavigationController(rootViewController: viewController)
        navigationController.present(presentingNavigationController, animated: true)
    }

}

extension DeliveryRouter {

    func applyNewUserAdress() {
        guard let navigationController = navigationController else { return }
        navigationController.dismiss(animated: true)
    }

}
