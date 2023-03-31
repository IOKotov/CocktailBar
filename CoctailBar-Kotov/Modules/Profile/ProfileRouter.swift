//
//  ProfileRouter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import UIKit

protocol ProfileRouterDelegate: AnyObject {
    func updateUserData(userName: String)
}

final class ProfileRouter: BaseRouter {

    weak var delegate: ProfileRouterDelegate?

    override func start() {
        let viewController = ProfileFabric.assembleScreen(router: self)

        let baseNavigationController = UINavigationController()
        baseNavigationController.configureTabBarItem(with: .profile)
        navigationController = baseNavigationController

        guard let navigationController = navigationController else { return }
        navigationController.setViewControllers([viewController], animated: false)
    }

}

// MARK: - Routing Methods

extension ProfileRouter {

    func logOut() {
        guard let navigationController = navigationController else { return }
        let alertController = UIAlertController(
            title: "Do you want log out?",
            message: nil,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            Session.shared.deleteKey()
            self?.routeToAuthorization()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        navigationController.present(alertController, animated: true)
    }

    func openFavoritesModule() {
        guard let navigationController = navigationController else { return }
        let router = FavoritesRouter(navigationController: navigationController)
        onNext(childRouter: router)
    }

    func openPromocodesModule() {
        guard let navigationController = navigationController else { return }
        let router = PromoCodesRouter(navigationController: navigationController)
        onNext(childRouter: router)
    }

    func openEditProfileModule(userName: String) {
        guard let navigationController = navigationController else { return }
        let router = EditProfileRouter(userName: userName, navigationController: navigationController)
        router.delegate = self
        onNext(childRouter: router)
    }

    func openOrderModule() {
        guard let navigationController = navigationController else { return }
        let router = OrderRouter(navigationController: navigationController)
        onNext(childRouter: router)
    }

    func routeToAuthorization() {
        let navigtionController = UINavigationController()
        let router = AuthorizationRouter(
            isTabItem: false,
            navigationController: navigtionController
        )
        router.start()

        let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        window?.rootViewController = navigtionController
    }

}

// MARK: - EditProfileRouterDelegate

extension ProfileRouter: EditProfileRouterDelegate {

    func applyChangeUserName(_ userName: String) {
        delegate?.updateUserData(userName: userName)
    }

}
