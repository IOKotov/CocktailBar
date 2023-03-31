//
//  BaseRouter.swift
//  CoctailBar-Kotov
//
//  Created by Dmitry Surkov on 07.07.2022.
//

import UIKit

protocol RouterInterface {
    func start()
}

class BaseRouter: RouterInterface {

    weak var window: UIWindow?
    weak var navigationController: UINavigationController?

    init(window: UIWindow?) {
        self.window = window
    }

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {}

    func onNext(childRouter: BaseRouter) {
        childRouter.start()
    }

}
