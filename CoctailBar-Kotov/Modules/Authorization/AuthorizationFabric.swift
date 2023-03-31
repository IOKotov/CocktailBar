//
//  AuthorizationFabric.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 18.07.2022.
//

import UIKit

class AuthorizationFabric {

    class func assembleScreen(router: AuthorizationRouter) -> AuthorizationViewController {
        let interactor = AuthorizationInteractor()
        let presenter = AuthorizationPresenter(router, interactor)
        let viewController = AuthorizationViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }

}
