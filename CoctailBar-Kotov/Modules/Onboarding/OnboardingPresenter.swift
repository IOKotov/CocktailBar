//
//  OnboardingPresenter.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 20.09.2022.
//

import Foundation

final class OnboardingPresenter {

    private let router: OnboardingRouter
    private let interactor: OnboardingInteractorInterface

    weak var viewController: OnboardingPageViewController?

    private var onboardingObjects: [Item] = []

    private(set) lazy var onboardingViewControllers: [OnboardingViewController] = []

    init(_ router: OnboardingRouter, _ interactor: OnboardingInteractorInterface) {
        self.router = router
        self.interactor = interactor
    }

    //MARK: - Helpers
 
    func loadData() {
        interactor.getOnboarding { [weak self] items in
            guard let self = self else { return }
            self.onboardingObjects = items
            DispatchQueue.main.async {
                self.prepareData()
            }
        }
    }

    func enterAuthorization() {
        router.openAutorizationModule()
    }

    func enterMainModule() {
        router.openMainModule()
    }

    //MARK: - Private helpers

    private func prepareData() {
        for object in onboardingObjects {
            let onboardingViewController = OnboardingViewController(item: object, presenter: self)
            onboardingViewControllers.append(onboardingViewController)
        }
        viewController?.populateView(onboardingViewControllers: onboardingViewControllers)
    }

}

