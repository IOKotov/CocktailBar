//
//  CartRouter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 12.08.2022.
//

import UIKit

protocol CartRouterDelegate: AnyObject {
    func removeDrinkFromCart(id: String)
}

final class CartRouter: BaseRouter {

    weak var delegate: CartRouterDelegate?

    override func start() {
        let viewController = CartFabric.assembleScreen(router: self)

        let baseNavigationController = UINavigationController()
        baseNavigationController.configureTabBarItem(with: .cart)
        navigationController = baseNavigationController

        guard let navigationController = navigationController else { return }
        navigationController.setViewControllers([viewController], animated: false)
    }

}

// MARK: - Routing Methods

extension CartRouter {

    func enteredInvalidPromocode() {

        let alertController = UIAlertController(
            title: "Invalid promo code entered",
            message: nil,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "Ok", style: .cancel)

        alertController.addAction(confirmAction)
        navigationController?.present(alertController, animated: true)
    }

    func openDrinkRemovingAlert(id: String) {
        let alertController = UIAlertController(
            title: "Do you want to remove drink?",
            message: nil,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in self?.delegate?.removeDrinkFromCart(id: id)
        }
        let declaindAction = UIAlertAction(title: "No", style: .cancel)

        alertController.addAction(confirmAction)
        alertController.addAction(declaindAction)
        navigationController?.present(alertController, animated: true)
    }

    func openDrinksModule() {
        navigationController?.tabBarController?.selectedIndex = TabBarController.TabItem.main.rawValue
    }

    func openCheckOutModule(totalPrice: String) {
        guard let navigationController = navigationController else { return }
        let router = CheckOutRouter(
            totalPrice: totalPrice,
            navigationController: navigationController
        )
        onNext(childRouter: router)
    }

}
