//
//  CheckOutRouter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 24.10.2022.
//

import UIKit

final class CheckOutRouter: BaseRouter {

    private let totalPrice: String

    init(totalPrice: String, navigationController: UINavigationController) {
        self.totalPrice = totalPrice
        
        super.init(navigationController: navigationController)
    }

    override func start() {
        guard let navigationController = navigationController else { return }
        let viewController = CheckOutFabric.assembleScreen(router: self, totalPrice: totalPrice)
        navigationController.pushViewController(viewController, animated: true)
    }

}

// MARK: - Routing Methods

extension CheckOutRouter {

    func successCreatedOrder() {
        guard let navigationController = navigationController else { return }
        let alertController = UIAlertController(
            title: "Your order has been created!",
            message: nil,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(confirmAction)
        navigationController.present(alertController, animated: true)
    }

    func openMapModule() {
        guard let navigationController = navigationController else { return }
        let router = MapRouter(navigationController: navigationController)
        onNext(childRouter: router)
    }
    
    func openDeliveryModule(delegate: DeliveryPresenterDelegate) {
        guard let navigationController = navigationController else { return }
        let router = DeliveryRouter(navigationController: navigationController, delegate: delegate)
        onNext(childRouter: router)
    }

}
