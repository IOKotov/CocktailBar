//
//  AuthorizationRouter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 18.07.2022.
//

import UIKit

final class AuthorizationRouter: BaseRouter {

    private let isTabItem: Bool

    init(isTabItem: Bool, navigationController: UINavigationController?) {
        self.isTabItem = isTabItem
        super.init(navigationController: navigationController)
    }

    override func start() {
        let viewController = AuthorizationFabric.assembleScreen(router: self)

        guard isTabItem else {
            guard let navigationController = navigationController else { return }
            navigationController.pushViewController(viewController, animated: false)
            return
        }
        let baseNavigationController = UINavigationController()
        baseNavigationController.configureTabBarItem(with: .profile)
        navigationController = baseNavigationController
        guard let navigationController = navigationController else { return }
        navigationController.setViewControllers([viewController], animated: false)
    }

}

// MARK: - Routing Methods

extension AuthorizationRouter {

    func authorizationComplete() {
        let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        let router = TabBarRouter(window: window)
        router.start()
    }

}
