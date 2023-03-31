//
//  PromoCodesRouter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import UIKit

final class PromoCodesRouter: BaseRouter {

    init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }

    override func start() {
        guard let navigationController = navigationController else { return }
        let viewController = PromoCodesFabric.assembleScreen(router: self)
        navigationController.pushViewController(viewController, animated: true)
    }

}

// MARK: - Routing Methods

extension PromoCodesRouter {

    func openAddPromocodesModule(_ promocode: Promocode? = nil) {
        guard let navigationController = navigationController else { return }
        let router = AddPromocodesRouter(navigationController: navigationController, promocode: promocode)
        onNext(childRouter: router)
    }
    
}
