//
//  TabBarRouter.swift
//  CoctailBar-Kotov
//
//  Created by Dmitry Surkov on 27.07.2022.
//

import UIKit

final class TabBarRouter: BaseRouter {

    private var routers: [BaseRouter] = []

    override func start() {
        setChildRouters()
        setRootViewController()
    }

}

// MARK: - Private Helpers

extension TabBarRouter {

    private func setRootViewController() {
        let tabBarController = TabBarController(routers)
        guard let window = window else { return }
        window.rootViewController = tabBarController
    }

    private func setChildRouters() {
        routers = [
            DrinksRouter(navigationController: nil),
            CartRouter(navigationController: nil),
        ]
        Session.shared.isUserAutorized() ? routers.append(ProfileRouter(navigationController: nil)) : routers.append(AuthorizationRouter(isTabItem: true, navigationController: nil))
    }

}
