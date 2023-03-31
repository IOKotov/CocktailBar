//
//  OnboardingInteractor.swift
//  CoctailBar-Kotov
//
//  Created by Илья Котов on 20.09.2022.
//

import Foundation

protocol OnboardingInteractorInterface {
    func getOnboarding(completion: @escaping ([Item]) -> Void)
}

final class OnboardingInteractor: OnboardingInteractorInterface {

    private let onboardingNetworkService = OnboardingNetworkService()

    func getOnboarding(completion: @escaping ([Item]) -> Void) {
        onboardingNetworkService.getOnboardingItems { item in
            guard let item = item else { completion([]); return }
            completion(item.items)
        }
    }

}
