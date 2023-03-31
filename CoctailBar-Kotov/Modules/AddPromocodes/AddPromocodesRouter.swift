//
//  AddPromocodesRouter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 08.09.2022.
//

import UIKit

final class AddPromocodesRouter: BaseRouter {

    private var promocode: Promocode?

    init(navigationController: UINavigationController, promocode: Promocode?) {
        self.promocode = promocode
        super.init(navigationController: navigationController)
    }

    override func start() {
        guard let navigationController = navigationController else { return }
        let viewController = AddPromocodesFabric.assembleScreen(router: self, promocode: promocode)
        let presentingNavigationController = UINavigationController(rootViewController: viewController)
        navigationController.present(presentingNavigationController, animated: true)
    }

    func dismiss() {
        guard let navigationController = navigationController else { return }
        navigationController.dismiss(animated: true)
    }

}
