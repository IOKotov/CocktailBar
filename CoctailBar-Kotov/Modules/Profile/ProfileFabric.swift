//
//  ProfileFabric.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 29.07.2022.
//

import UIKit

class ProfileFabric {

    class func assembleScreen(router: ProfileRouter) -> ProfileViewController {
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter(router, interactor)
        router.delegate = presenter
        let viewController = ProfileViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }

}
