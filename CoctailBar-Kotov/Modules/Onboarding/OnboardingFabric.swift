//
//  OnboardingFabric.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 20.09.2022.
//

import Foundation

class OnboardingFabric {

    class func assembleScreen(router: OnboardingRouter) -> OnboardingPageViewController {
        let interactor: OnboardingInteractorInterface = OnboardingInteractor()
        let presenter = OnboardingPresenter(router, interactor)
        let viewController = OnboardingPageViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }

}
