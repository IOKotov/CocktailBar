//
//  OnboardingRouter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 20.09.2022.
//

import UIKit

final class OnboardingRouter: BaseRouter {

    override func start() {
        let viewController = OnboardingFabric.assembleScreen(router: self)
        guard let navigationController = navigationController else { return }
        navigationController.setViewControllers([viewController], animated: false)
    }

}

// MARK: - Routing Methods

extension OnboardingRouter {

    func openMainModule() {
        let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        let router = TabBarRouter(window: window)
        router.start()
        Session.shared.writeFirstLaunch()
    }

    func openAutorizationModule() {
        guard let navigationController = navigationController else { return }
        let router = AuthorizationRouter(isTabItem: false, navigationController: navigationController)
        onNext(childRouter: router)
        Session.shared.writeFirstLaunch()
    }

}
